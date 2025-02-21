import os

instruction_set = {
    'add': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x20'],
    'addi': ['0x08', 'rs', 'rt', 'imm'],
    'sub': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x22'],
    'and': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x24'],
    'or': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x25'],
    'xor': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x26'],
    'nor': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x27'],
    'slt': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x2A'],
    'sll': ['0x00', 'rt', 'rd', 'shamt', '0x00', '0x00'],
    'srl': ['0x00', 'rt', 'rd', 'shamt', '0x00', '0x02'],
    'slti': ['0x0A', 'rs', 'rt', 'imm'],
    'sgt': ['0x00', 'rs', 'rt', 'rd', '0x00', '0x2B'],
    'lw': ['0x23', 'rs', 'rt', 'imm'],
    'sw': ['0x2B', 'rs', 'rt', 'imm'],
    'beq': ['0x04', 'rs', 'rt', 'imm'],
    'bne': ['0x05', 'rs', 'rt', 'imm'],
    'j': ['0x02', 'address'],
    'jr': ['0x00', 'rs', '0x00', '0x08'],
    'jal': ['0x03', 'address'],
    'ori': ['0x0D', 'rs', 'rt', 'imm'],
    'xori': ['0x0E', 'rs', 'rt', 'imm'],
    'andi': ['0x0C', 'rs', 'rt', 'imm']
}

register_set = {f"${i}": format(i, '05b') for i in range(32)}


def to_binary(value, bits):
    if isinstance(value, str) and value.startswith("0x"):
        value = int(value, 16)
    if value < 0:
        value = (1 << bits) + value
    return format(value, f'0{bits}b')[-bits:]  # Ensure the result is exactly 'bits' long


def assemble_r_type(opcode, rs, rt, rd, shamt, funct):
    return f"{opcode}{rs}{rt}{rd}{shamt}{funct}"


def assemble_i_type(opcode, rs, rt, imm):
    return f"{opcode}{rs}{rt}{imm}"


def assemble_j_type(opcode, address):
    return f"{opcode}{address}"


def parse_instruction(instruction):
    return instruction.replace(",", "").split()


def first_pass(instructions):
    labels = {}
    pc = 0
    for instruction in instructions:
        parts = parse_instruction(instruction)
        if not parts:
            continue
        if parts[0].endswith(':'):  # Check for a label
            label = parts[0][:-1]
            labels[label] = pc
        else:
            op = parts[0]
            if op in ['bgez', 'bltz']:
                pc += 2
            else:
                pc += 1
    return labels


def assemble_instruction(instruction, labels=None, pc=0):
    parts = parse_instruction(instruction)
    op = parts[0]

    # R-Type Instructions (add, sub, and, or, etc.)
    if op in ['add', 'sub', 'and', 'or', 'xor', 'nor', 'slt', 'sgt']:
        rd = register_set[parts[1]]
        rs = register_set[parts[2]]
        rt = register_set[parts[3]]
        opcode = to_binary(int(instruction_set[op][0], 16), 6)
        shamt = '00000'
        funct = to_binary(int(instruction_set[op][5], 16), 6)
        return assemble_r_type(opcode, rs, rt, rd, shamt, funct)

    # Shift Instructions (sll, srl)
    elif op in ['sll', 'srl']:
        rd = register_set[parts[1]]
        rt = register_set[parts[2]]
        shamt = to_binary(int(parts[3]), 5)
        opcode = to_binary(int(instruction_set[op][0], 16), 6)
        funct = to_binary(int(instruction_set[op][5], 16), 6)
        return assemble_r_type(opcode, '00000', rt, rd, shamt, funct)

    # I-Type Instructions (addi, slti, lw, sw, beq, bne, etc.)
    elif op in ['addi', 'slti', 'ori', 'xori', 'andi', 'lw', 'sw', 'beq', 'bne']:
        rt = register_set[parts[1]]

        if op in ['lw', 'sw']:
            offset_with_register = parts[2]
            offset, register = offset_with_register.split('(')
            rs = register_set[register.strip(')')]
            imm = to_binary(int(offset, 16), 16)
        else:
            rs = register_set[parts[2]]
            if parts[3] in labels and op in ['beq', 'bne']:
                label_address = labels[parts[3]]
                imm = to_binary((label_address - pc - 1), 16)
            else:
                imm = to_binary(int(parts[3], 16), 16)

        opcode = to_binary(int(instruction_set[op][0], 16), 6)
        return assemble_i_type(opcode, rs, rt, imm)

    # J-Type Instructions (j, jal)
    elif op in ['j', 'jal']:
        address = to_binary(labels[parts[1]], 26) if parts[1] in labels else to_binary(int(parts[1]), 26)
        opcode = to_binary(int(instruction_set[op][0], 16), 6)
        return assemble_j_type(opcode, address)

    # JR Instruction
    elif op == 'jr':
        rs = register_set[parts[1]]
        opcode = to_binary(int(instruction_set[op][0], 16), 6)
        funct = to_binary(int(instruction_set[op][3], 16), 6)
        return assemble_r_type(opcode, rs, '00000', '00000', '00000', funct)

    elif op == 'bgez':
        rs = register_set[parts[1]]
        label = parts[2]
        slti_instr = f"slti {parts[1]}, {parts[1]}, 0"  # Compare $rs with 0
        beq_instr = f"beq {parts[1]}, $0, {label}"  # Branch if >= 0
        return [assemble_instruction(slti_instr, labels, pc), assemble_instruction(beq_instr, labels, pc + 1)]

    elif op == 'bltz':
        rs = register_set[parts[1]]
        label = parts[2]
        slti_instr = f"slti {parts[1]}, {parts[1]}, 0"  # Compare $rs with 0
        bne_instr = f"bne {parts[1]}, $0, {label}"  # Branch if < 0
        return [assemble_instruction(slti_instr, labels, pc), assemble_instruction(bne_instr, labels, pc + 1)]

    return ''  # Unrecognized instruction


def second_pass(instructions, labels):
    machine_code = []
    pc = 0
    for instruction in instructions:
        parts = parse_instruction(instruction)
        if not parts:  # Skip empty lines
            continue
        if parts[0].endswith(':'):
            parts = parts[1:]  # Ignore label name
            if not parts:
                continue
        print(f"Processing instruction at PC {pc}: {instruction}")
        result = assemble_instruction(" ".join(parts), labels, pc)
        if isinstance(result, list):  # Handle multiple instructions for pseudo-instructions
            for sub_result in result:
                machine_code.append(sub_result)
                pc += 1
        else:
            machine_code.append(result)
            pc += 1
    return machine_code


def assemble_to_hex(instruction, labels, pc):
    binary_code = assemble_instruction(instruction, labels, pc)
    return hex(int(binary_code, 2))[2:].zfill(8) if binary_code else '00000000'

def write_on_mif(machine_code, filename):
    mif_depth = 256
    width = 32

    with open(filename, "w") as mif:
        mif.write("WIDTH=32;\n")
        mif.write("DEPTH=256;\n")
        mif.write("ADDRESS_RADIX=UNS;\n")
        mif.write("DATA_RADIX=BIN;\n\n")
        mif.write("CONTENT BEGIN\n")

        for address, instr in enumerate(machine_code):
            instr = instr.zfill(width)
            mif.write(f"{address}: {instr};\n")

        if len(machine_code) < mif_depth:
            mif.write(f"\n   [{len(machine_code)}..255] : {'0' * width};\n")
        mif.write("END;\n")
def create_mif(machine_code, benchmark_name, output_dir=r"C:\Users\Windows\Desktop\phaseIII_git\cache-me-if-you-can\dual_proc_quartus\benchmarksMIF"):

    filename = f"{benchmark_name}.mif"
    file_path = os.path.join(output_dir, filename)

    mif_depth = 256
    width = 32

    with open(file_path, "w") as mif:
        mif.write("WIDTH=32;\n")
        mif.write("DEPTH=256;\n")
        mif.write("ADDRESS_RADIX=UNS;\n")
        mif.write("DATA_RADIX=BIN;\n\n")
        mif.write("CONTENT BEGIN\n")

        for address, instr in enumerate(machine_code):
            instr = instr.zfill(width)
            mif.write(f"{address}: {instr};\n")

        if len(machine_code) < mif_depth:
            mif.write(f"\n   [{len(machine_code)}..255] : {'0' * width};\n")
        mif.write("END;\n")


if __name__ == "__main__":
    code = """
ADDI $17, $0, 10 
ANDI $18, $0, 0   
XORI $24, $0, 2 
Outer_Loop: 
ADD $19, $18, $0
LW $25, 0x0($19) 
JAL Mul_Fun 
SW $23, 0x0($19)
ADDI $18, $18, 1 
SUB  $20, $18, $17 
BLTZ $20, Outer_Loop 
J Finish 
Mul_Fun :  
ANDI $23, $0, 0 
ADDI $22, $25, -1  
Mul_Loop :   
ADD  $23, $23, $24 
ADDI $22, $22, -1  
BGEZ $22, Mul_Loop 
JR $31 
Finish : 
sll $0, $0, 0       
"""
    code = code.split('\n')

    to_remove = []
    for i, line in enumerate(code):
        if len(line) == 0 or line[0] == '#':
            to_remove.append(i)

    instruction_test = [line.lower().strip() for i, line in enumerate(code) if i not in to_remove]

    labels = first_pass(instruction_test)
    print("Labels:", labels)
    machine_code = second_pass(instruction_test, labels)
    print("\nMachine Code:")
    i = 0
    print("\nMachine Code:")
    for i, line in enumerate(machine_code):
        print(f"{i}: {line};")
    create_mif(machine_code, "Swapping", r"C:\Users\Windows\Desktop\phaseIII_git\cache-me-if-you-can\dual_proc_quartus\benchmarksMIF")
    write_on_mif(machine_code, filename=r"C:\Users\Windows\Desktop\phaseIII_git\cache-me-if-you-can\dual_proc_quartus\instructionMemoryInitializationFile.mif")
