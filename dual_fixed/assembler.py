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

# --- Helper functions to compute used registers ---

def get_used_registers(instructions):
    used = set()
    for instr in instructions:
        parts = parse_instruction(instr)
        for part in parts:
            if part.startswith("$"):
                used.add(part)
    return used

def get_unused_register(used):
    # Skip $0 since it's hardwired to 0
    for i in range(1, 32):
        r = f"${i}"
        if r not in used:
            return r
    return None

# --- New functions to allocate a unique temporary register per pseudo-instruction ---
# We first initialize a list of available registers that are not used anywhere in the program.
def initialize_available_regs(instructions):
    used = get_used_registers(instructions)
    avail = []
    for i in range(1, 32):
        r = f"${i}"
        if r not in used:
            avail.append(r)
    return avail

available_regs = []  # Global list that will be initialized in main

def get_temp_reg():
    global available_regs
    if available_regs:
        return available_regs.pop(0)
    else:
        # Fallback if no unused registers remain
        return "$1"

# --- End of new temporary register allocation functions ---

def to_binary(value, bits):
    if isinstance(value, str) and value.startswith("0x"):
        value = int(value, 16)
    else: 
        value = int(value)
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
    if not parts:
        return ''
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

    # I-Type Instructions (addi, slti, lw, sw, beq, bne, ori, xori, andi)
    elif op in ['addi', 'slti', 'ori', 'xori', 'andi', 'lw', 'sw', 'beq', 'bne']:
        if op in ['beq', 'bne']:
            rs = register_set[parts[1]]
            rt = register_set[parts[2]]
        else:
            rt = register_set[parts[1]]

        if op in ['lw', 'sw']:
            offset_with_register = parts[2]
            offset, register = offset_with_register.split('(')
            rs = register_set[register.strip(')')]
            imm = to_binary(int(offset, 16), 16)
        else:
            if op not in ['beq', 'bne']:  # rs already handled for beq/bne
                rs = register_set[parts[2]]
            if parts[3] in labels and op in ['beq', 'bne']:
                label_address = labels[parts[3]]
                imm = to_binary((label_address - (pc + 1)), 16)
            else:
                imm = to_binary((parts[3]), 16)

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

    # Pseudo-instructions: expand into two instructions
    elif op == 'bgez':
        # Expand "bgez $rs, label" into:
        #   slti $temp, $rs, 0
        #   beq  $temp, $0, label
        temp_reg = get_temp_reg()
        label = parts[2]
        slti_instr = f"slti {temp_reg}, {parts[1]}, 0"
        beq_instr  = f"beq {temp_reg}, $0, {label}"
        print(f"Processing instruction at PC {pc}: {slti_instr}")
        print(f"Processing instruction at PC {pc+1}: {beq_instr}")
        return [assemble_instruction(slti_instr, labels, pc),
                assemble_instruction(beq_instr, labels, pc + 1)]

    elif op == 'bltz':
        # Expand "bltz $rs, label" into:
        #   slti $temp, $rs, 0
        #   bne  $temp, $0, label
        temp_reg = get_temp_reg()
        label = parts[2]
        slti_instr = f"slti {temp_reg}, {parts[1]}, 0"
        bne_instr  = f"bne {temp_reg}, $0, {label}"
        print(f"Processing instruction at PC {pc}: {slti_instr}")
        print(f"Processing instruction at PC {pc+1}: {bne_instr}")
        return [assemble_instruction(slti_instr, labels, pc),
                assemble_instruction(bne_instr, labels, pc + 1)]

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

def create_instruction_file(instr, benchmark_name, output_dir=r"C:\Users\Windows\Desktop\phaseIII_git\cache-me-if-you-can\dual_proc_quartus\benchmarks_instructions"):
    filename = f"{benchmark_name}.txt"
    file_path = os.path.join(output_dir, filename)
    with open(file_path, "w") as txt:
        txt.write('\n'.join(instr))

if __name__ == "__main__":

    
    code = """
ADDI $2, $0, 0x2  
ADDI $3, $0, 0x3 
ADDI $4, $0, 0x4 
ADDI $5, $0, 0x5
ADDI $6, $0, 0x6
ADDI $7, $0, 0x7
ADDI $8, $0, 0x8 
ADDI $9, $0, 0x9 
ADDI $10, $0, 0xa
ADDI $11, $0, 0xb 
ADDI $12, $0, 0xc  
ADDI $15, $0, 0xf
ADD $2, $2, $3  
SUB $4, $2, $5   
LW  $4, 0($2)  
SUB $2, $3, $5  
SW  $5, 0($2)   
LW  $3, 0($2)   
LW  $3, 0($2)   
SW  $4, 0($2)   
SW  $4, 0($3)  
SW  $5, 0($3)   
BEQ $6, $0, miss  
ADDI $6, $6, 0x1  
miss: 
BEQ  $7, $0, t1  
BEQ  $7, $7, t2  
t1:
ADDI $7, $0, 0x1
SUB  $7, $7, $7 
t2: 
BEQ  $7, $0, t1  
BNE  $7, $7, t2  
BEQ $8, $8, t3  
SUB $8, $8, $8
ADDI $8, $0, 0x8
SUB  $8, $8, $8  
t3: 
BEQ $9, $0, t3
BEQ $9, $8, t4  
BEQ $10, $10, t4
BEQ $11, $11, t3
SUB  $10, $10, $10 
SUB  $11, $11, $11 
t4: 
ADDI $31, $0, t5   
JAL t5    
SUB $31, $31, $31
sll $0, $0 ,0        
t5: 
ADDI $31, $0, t6   
ADDI $12, $0, 0xc 
BEQ  $12, $0, skip 
JR $31      
skip: 
SUB $12, $12, $12
SUB $31, $31, $31
t6:
ADDI $31, $0, t7
JR $31
SUB $31, $31, $31
sll $0, $0 ,0 
t7: 
ADDI $31, $0, t8
JR $31 
t8: 
LW  $13, 0($2) 
BNE $13, $0, t9
SUB $13, $13, $13
sll $0, $0 ,0  
t9:
ADDI $14, $0, t10  
JR $14  
J t1
t10:      
sll $0, $0 ,0 
JAL t11
J t12
SUB $31, $31, $31
SUB $31, $31, $31 
t11: 
JR $31  
SUB $31, $31, $31  
t12:
JAL t13
t13:
JAL t14
t14: 
BEQ $15, $0, t15
J t16
t15: 
SUB $15, $15, $15
sll $0, $0 ,0 
t16: 
LW  $16, 0($2)
J t17
SUB $16, $16, $16
sll $0, $0 ,0 
t17: 
J t18        
BEQ $18, $0, t19 
t18: 
ADDI $18, $0, 0x12  
t19: 
SUB $18, $18, $18  
sll $0, $0 ,0 
"""
    code = code.split('\n')

    to_remove = []
    for i, line in enumerate(code):
        if len(line) == 0 or line[0] == '#':
            to_remove.append(i)
    instruction_test = [line.lower().strip() for i, line in enumerate(code) if i not in to_remove]

    # --- Initialize the pool of available registers for pseudo-instruction expansion ---
    available_regs = initialize_available_regs(instruction_test)
    # --- End of temporary register setup ---

    labels = first_pass(instruction_test)
    print("Labels:", labels)
    machine_code = second_pass(instruction_test, labels)
    print("\nMachine Code:")
    for i, line in enumerate(machine_code):
        print(f"{i}: {line};")
    create_mif(machine_code, "Edge Cases", r"C:\Users\Windows\Desktop\phaseIII_git\cache-me-if-you-can\dual_proc_quartus\benchmarksMIF")
    write_on_mif(machine_code, filename=r"C:\Users\Windows\Desktop\phaseIII_git\cache-me-if-you-can\dual_proc_quartus\instructionMemoryInitializationFile.mif")
    create_instruction_file(code, "Edge Cases_Scheduler_Instruction", output_dir=r"C:\Users\Windows\Desktop\phaseIII_git\cache-me-if-you-can\dual_proc_quartus\benchmarks_instructions")
