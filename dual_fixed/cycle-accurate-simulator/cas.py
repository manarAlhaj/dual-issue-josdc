# A cycle accurate simulator for a 5-stage pipeline MIPS processor

import numpy as np
import pickle
import time
import os

INSTRUCTIONMEMORYSIZE = 2**6
DATAMEMORYSIZE = 2**6

timeStr = str(int(time.time()))
currentDirectory = os.getcwd()
initDirectory = os.path.join(currentDirectory, 'init')
runDirectory = os.path.join(currentDirectory, 'runs', timeStr)
os.makedirs(runDirectory)


# Class definitions for modules whose entry point is well defined; modules where the same inputs are always processed in the same way to produce the same outputs
class Registers:
    def __init__(self):
        self.structure = np.zeros((32, 32), dtype=bool)
    
    def access(self, index):
        # Access returns a copy of the element to not have the changes done to that element be reflected in the returned values
        return np.array(self.structure[index])

    def process(self, readRegister1, readRegister2, writeRegister, writeData, regWrite):
        target = bitsToNum(writeRegister)
        if regWrite and target != 0:
            self.structure[target] = writeData
        # Data reading happens after the writing to simulate the behavior of the actual processor, where writing happens on the negative edge of the clock,
        # making the value of readData towards the end of the cycle be the updated, written value
        readData1, readData2 = self.access(bitsToNum(readRegister1)), self.access(bitsToNum(readRegister2))
        return readData1, readData2
    
    def store(self, cycleStr):
        filepath = os.path.join(runDirectory, f'{cycleStr}registers.npy')
        np.save(filepath, self.structure)


class InstructionMemory:
    def __init__(self):
        filepath = os.path.join(initDirectory, 'instructionMemory.npy')
        try:
            self.structure = np.load(filepath)
        except FileNotFoundError:
            print("Instruction memory initialization file does not exist")
            exit()

    def process(self, address):
        addy = bitsToNum(address)
        instruction = self.structure[addy]
        return instruction


class DataMemory:
    def __init__(self):
        filepath = os.path.join(initDirectory, 'dataMemory.npy')
        if os.path.exists(filepath):
            self.structure = np.load(filepath)
        else:
            self.structure = np.zeros((DATAMEMORYSIZE, 32), dtype=bool)
    
    def access(self, index):
        # Access returns a copy of the element to not have the changes done to that element be reflected in the returned values
        return np.array(self.structure[index])

    def process(self, address, writeData, memWrite, memRead):
        addy = bitsToNum(address)
        readData = np.zeros(32, dtype=bool)
        if memRead:
            readData = self.access(addy)
        if memWrite:
            self.structure[addy] = writeData
        return readData
    
    def store(self, cycleStr):
        filepath = os.path.join(runDirectory, f'{cycleStr}DM.npy')
        np.save(filepath, self.structure)


# Helper functions definitions
def slice(*args):
    # Returns the expected array slicing given verilog-style index arguments
    arr = args[0]
    m = len(arr)-1
    a = args[1]
    if len(args) == 2:
        return arr[(m-a)]
    else:
        b = args[2]
        return arr[(m-a): (m-b)+1]

def fullAdder(A, B, Cin):
    # A 1-bit full adder
    A, B, Cin = tuple(map(int, (A, B, Cin)))
    S = (A+B+Cin) % 2 == 1
    Cout = (A+B+Cin) > 1
    return S, Cout

def adder(a, b):
    # A variable-bit ripple carry adder
    carry = False
    if type(a) != np.ndarray:
        return fullAdder(a, b, carry)  
    length = len(a)      
    result = np.zeros(length, dtype=bool)
    for i in range(length-1, -1, -1):
        result[i], carry = fullAdder(a[i], b[i], carry)
    return result, carry

def addition(a, b):
    # A wrapper for addition that doesn't use the carry value
    return adder(a, b)[0]

def negate(number):
    # Converts a number to the two's complement representation of its negative
    inverted = np.invert(number)
    one = np.zeros(len(number), dtype=bool)
    one[-1] = 1
    return addition(inverted, one)

def subtracter(a, b):
    return adder(a, negate(b))

def subtraction(a, b):
    return subtracter(a, b)[0]

def bitsToNum(arr):
    # Converts the unsigned bit representation of a number to its decimal one
    return np.sum(arr*np.power(np.full(len(arr), 2), np.arange(len(arr)))[::-1])

def bitsToNumSigned(arr):
    # Converts the signed bit representation of a number to its decimal one
    if arr[0]:
        return -bitsToNum(negate(arr))
    return bitsToNum(arr)

def mux(*args):
    # An implementation of a mux that takes a variable number of arguments, assuming the last argument to be an unsigned bit representation of the selector line
    if type(args[-1]) is bool:
        selector = int(args[-1])
    else:
        selector = bitsToNum(args[-1])
    return args[selector]

def humanReadable(signal):
    # Converts an array of boolean value to a readable string
    print(''.join('1' if bit else '0' for bit in signal))

# Module initialization
gpRegisters = Registers()
instructionMemory = InstructionMemory()
dataMemory = DataMemory()
registers = dict()

# The pipeline registers dictionary, each pipe name being a key to a list of pairs, each pair being a register's name and the number of its bits
pipelineRegisters = {
"IF / ID":
[("instrFD", 32), ("PCPlusFD", 6), ("PCFD", 6), ("PCBranchFD", 6), ("predictionFD", 1)],
"ID / EX":
[('RdDE', 5), ('RtDE', 5), ('RsDE', 5), ('SignImmDE', 32), ('RD1DE', 32), ('RD2DE', 32), ("RegWriteDE", 1), ("MemtoRegDE", 2), ("MemWriteDE", 1), ("ALUControlDE", 4), ("ALUSrcDE", 1),
    ("RegDstDE", 2), ("BranchDE", 1), ("shamtDE", 5), ("PCPlusDE", 6), ("MemReadEnDE", 1), ("bit26DE", 1), ("PCBranchDE", 6), ("predictionDE", 1), ("PCDE", 6)],
"EX / MEM":
[("ALUOutEM", 32), ("WriteDataEM", 32), ("RegWriteEM", 1), ("MemtoRegEM", 2), ("MemWriteEM", 1), ("WriteRegEM", 5), ("PCPlusEM", 6), ("MemReadEnEM", 1)],
"MEM / WB":
[("ReadDataMW", 32), ("ALUOutMW", 32), ("MemtoRegMW", 2), ("RegWriteMW", 1), ("PCPlusMW", 6), ("WriteRegMW", 5)]
}

# BPU data structures initializations
takenCounter = np.zeros(64, dtype=int)
takenCounter[:] = 1
notTakenCounter = np.zeros(64, dtype=int)
notTakenCounter[:] = 2
globalHistory = np.zeros(6, dtype=bool)

# Cycle and instruction counters and halting decision variables initialization
cycle = 0
instructions = 0
stopExecuting = False
countDown = 3

while not (stopExecuting and (countDown == 0)):
    # Reading the registers, which will either be 
    PCF = registers.get('PC', np.zeros(6, dtype=bool))

    instrD = registers.get('instrFD', np.zeros(32, dtype=bool))
    PCPlusD = registers.get('PCPlusFD', np.zeros(6, dtype=bool))
    PCD = registers.get('PCFD', np.zeros(6, dtype=bool))
    PCBranchD = registers.get('PCBranchFD', np.zeros(6, dtype=bool))
    predictionD = registers.get('predictionFD', False)

    RdE = registers.get('RdDE', np.zeros(5, dtype=bool))
    RtE = registers.get('RtDE', np.zeros(5, dtype=bool))
    RsE = registers.get('RsDE', np.zeros(5, dtype=bool))
    SignImmE = registers.get('SignImmDE', np.zeros(32, dtype=bool))
    RD1E = registers.get('RD1DE', np.zeros(32, dtype=bool))
    RD2E = registers.get('RD2DE', np.zeros(32, dtype=bool))
    RegWriteE = registers.get('RegWriteDE', False)
    MemtoRegE = registers.get('MemtoRegDE', np.zeros(2, dtype=bool))
    MemWriteE = registers.get('MemWriteDE', False)
    ALUControlE = registers.get('ALUControlDE', np.zeros(4, dtype=bool))
    ALUSrcE = registers.get('ALUSrcDE', False)
    RegDstE = registers.get('RegDstDE', np.zeros(2, dtype=bool))
    BranchE = registers.get('BranchDE', False)
    shamtE = registers.get('shamtDE', np.zeros(5, dtype=bool))
    PCPlusE = registers.get('PCPlusDE', np.zeros(6, dtype=bool))
    MemReadEnE = registers.get('MemReadEnDE', False)
    bit26E = registers.get('bit26DE', False)
    PCBranchE = registers.get('PCBranchDE', np.zeros(6, dtype=bool))
    predictionE = registers.get('predictionDE', False)
    PCE = registers.get('PCDE', np.zeros(6, dtype=bool))

    ALUOutM = registers.get('ALUOutEM', np.zeros(32, dtype=bool))
    WriteDataM = registers.get('WriteDataEM', np.zeros(32, dtype=bool))
    RegWriteM = registers.get('RegWriteEM', False)
    MemtoRegM = registers.get('MemtoRegEM', np.zeros(2, dtype=bool))
    MemWriteM = registers.get('MemWriteEM', False)
    WriteRegM = registers.get('WriteRegEM', np.zeros(5, dtype=bool))
    PCPlusM = registers.get('PCPlusEM', np.zeros(6, dtype=bool))
    MemReadEnM = registers.get('MemReadEnEM', False)

    ReadDataW = registers.get('ReadDataMW', np.zeros(32, dtype=bool))
    ALUOutW = registers.get('ALUOutMW', np.zeros(32, dtype=bool))
    MemtoRegW = registers.get('MemtoRegMW', np.zeros(2, dtype=bool))
    RegWriteW = registers.get('RegWriteMW', False)
    PCPlusW = registers.get('PCPlusMW', np.zeros(6, dtype=bool))
    WriteRegW = registers.get('WriteRegMW', np.zeros(5, dtype=bool))

    # Forwarding unit
    ForwardA = np.zeros(2, dtype=bool)
    ForwardA[1] = RegWriteM and np.array_equal(WriteRegM, RsE) and np.any(WriteRegM)
    ForwardA[0] = RegWriteW and np.array_equal(WriteRegW, RsE) and np.any(WriteRegW) and not ForwardA[1]
    ForwardB = np.zeros(2, dtype=bool)
    ForwardB[1] = RegWriteM and np.array_equal(WriteRegM, RtE) and np.any(WriteRegM)
    ForwardB[0] = RegWriteW and np.array_equal(WriteRegW, RtE) and np.any(WriteRegW) and not ForwardB[1]


    # The order of the stages was reversed for sequential necessity; to make sure the values passed back to earlier stages are updated when called
    # ----------------------------------------- Writeback Stage ---------------------------------------
    ResultW = mux(ALUOutW, ReadDataW, PCPlusW, MemtoRegW)


    # ----------------------------------------- Memory Stage ---------------------------------------
    ReadDataM = dataMemory.process(address=slice(ALUOutM, 5, 0), writeData=WriteDataM, memWrite=MemWriteM, memRead=MemReadEnM)


    # ----------------------------------------- Execute Stage ---------------------------------------
    # ALU input processing logic
    WriteRegE = mux(RtE, RdE, np.ones(5, dtype=bool), RegDstE)
    SrcAE = mux(RD1E, ALUOutM, ResultW, ForwardA)
    WriteDataE = mux(RD2E, ALUOutM, ResultW, ForwardB)
    SrcBE = mux(WriteDataE, SignImmE, ALUSrcE)

    # Branch equality checks
    equalE = np.array_equal(SrcAE, WriteDataE)
    xnorOut = not equalE == bit26E
    
    # ALU logic
    ALUOpE = bitsToNum(ALUControlE)
    ALUOutE = np.zeros(32, dtype=bool)
    if ALUOpE == 0:
        ALUOutE = addition(SrcAE, SrcBE)
    elif ALUOpE == 1:
        ALUOutE = subtraction(SrcAE, SrcBE)
    elif ALUOpE == 2:
        ALUOutE = np.logical_and(SrcAE, SrcBE)
    elif ALUOpE == 3:
        ALUOutE = np.logical_or(SrcAE, SrcBE)
    elif ALUOpE == 4:
        ALUOutE = np.logical_xor(SrcAE, SrcBE)
    elif ALUOpE == 5:
        # NOR
        ALUOutE = np.logical_not(np.logical_or(SrcAE, SrcBE))
    elif ALUOpE == 6:
        # SLT
        ALUOutE[-1] = bitsToNumSigned(SrcAE) < bitsToNumSigned(SrcBE)
    elif ALUOpE == 7:
        # Shift left
        shiftVal = bitsToNum(shamtE)
        ALUOutE = np.roll(SrcBE, -shiftVal)
        ALUOutE[-shiftVal:] = 0
    elif ALUOpE == 8:
        # Shift right
        shiftVal = bitsToNum(shamtE)
        ALUOutE = np.roll(SrcBE, shiftVal)
        ALUOutE[: shiftVal] = 0
    elif ALUOpE == 9:
        # SGT
        ALUOutE[-1] = bitsToNumSigned(SrcAE) > bitsToNumSigned(SrcBE)

    # ALU flags calculation
    zeroFlagE = not np.any(ALUOutE)
    OVFE = (ALUOutE[0] and not SrcAE[0] and not SrcBE[0]) or (not ALUOutE[0] and SrcAE[0] and SrcBE[0])
    addy = bitsToNumSigned(addition(SrcAE, SrcBE))
    MemoryOoBE = (addy > 255) or (addy < 0)


    # ----------------------------------------- Decode Stage ---------------------------------------
    RdD = slice(instrD, 15, 11)
    RtD = slice(instrD, 20, 16)
    RsD = slice(instrD, 25, 21)
    shamtD = slice(instrD, 10, 6)
    immDecode = slice(instrD, 15, 0)
    bit26D = slice(instrD, 26)

    RD1D, RD2D = gpRegisters.process(readRegister1=RsD, readRegister2=RtD, writeRegister=WriteRegW, writeData=ResultW, regWrite=RegWriteW)

    # Control unit logic
    OpD = slice(instrD, 31, 26)
    FunctD = slice(instrD, 5, 0)

    RegDstD = np.array([0, 0], dtype=bool)
    BranchD = False
    MemReadEnD = False
    MemtoRegD = np.array([0, 0], dtype=bool)
    MemWriteD = False
    RegWriteD = False
    ALUSrcD = False
    JumpD = False
    PCSrcD = False
    ALUControlD = np.array([0, 0, 0, 0], dtype=bool)
    SignExtD = False

    if (OpD == np.array([0, 0, 0, 0, 0, 0], dtype=bool)).all():
        # OPCODE_R_TYPE
        RegDstD = np.array([0, 1], dtype=bool)
        RegWriteD = True
        if (FunctD == np.array([1, 0, 0, 0, 0, 0], dtype=bool)).all():
            # ADD
            ALUControlD = np.array([0, 0, 0, 0], dtype=bool)
        if (FunctD == np.array([1, 0, 0, 0, 1, 0], dtype=bool)).all():
            # SUB
            ALUControlD = np.array([0, 0, 0, 1], dtype=bool)
        if (FunctD == np.array([1, 0, 0, 1, 0, 0], dtype=bool)).all():
            # AND
            ALUControlD = np.array([0, 0, 1, 0], dtype=bool)
        if (FunctD == np.array([1, 0, 0, 1, 0, 1], dtype=bool)).all():
            # OR
            ALUControlD = np.array([0, 0, 1, 1], dtype=bool)
        if (FunctD == np.array([1, 0, 0, 1, 1, 0], dtype=bool)).all():
            # XOR
            ALUControlD = np.array([0, 1, 0, 0], dtype=bool)
        if (FunctD == np.array([1, 0, 0, 1, 1, 1], dtype=bool)).all():
            # NOR
            ALUControlD = np.array([0, 1, 0, 1], dtype=bool)
        if (FunctD == np.array([1, 0, 1, 0, 1, 0], dtype=bool)).all():
            # SLT
            ALUControlD = np.array([0, 1, 1, 0], dtype=bool)
        if (FunctD == np.array([0, 0, 0, 0, 0, 0], dtype=bool)).all():
            # SLL
            ALUControlD = np.array([0, 1, 1, 1], dtype=bool)
        if (FunctD == np.array([0, 0, 0, 0, 1, 0], dtype=bool)).all():
            # SRL
            ALUControlD = np.array([1, 0, 0, 0], dtype=bool)
        if (FunctD == np.array([1, 0, 1, 0, 1, 1], dtype=bool)).all():
            # SGT
            ALUControlD = np.array([1, 0, 0, 1], dtype=bool)
        if (FunctD == np.array([0, 0, 1, 0, 0, 0], dtype=bool)).all():
            # JR
            PCSrcD = True
    
    if (OpD == np.array([1, 0, 0, 0, 1, 1], dtype=bool)).all():
        # OPCODE_LW
        MemReadEnD = True
        MemtoRegD = np.array([0, 1], dtype=bool)
        RegWriteD = True
        ALUSrcD = True

    if (OpD == np.array([1, 0, 1, 0, 1, 1], dtype=bool)).all():
        # OPCODE_SW
        MemWriteD = True
        ALUSrcD = True

    if (OpD == np.array([0, 0, 1, 0, 0, 0], dtype=bool)).all():
        # OPCODE_ADDI
        RegWriteD = True
        ALUSrcD = True
        SignExtD = True

    if (OpD == np.array([0, 0, 1, 1, 0, 1], dtype=bool)).all():
        # OPCODE_ORI
        ALUControlD = np.array([0, 0, 1, 1], dtype=bool)
        RegWriteD = True
        ALUSrcD = True

    if (OpD == np.array([0, 0, 1, 1, 1, 0], dtype=bool)).all():
        # OPCODE_XORI
        ALUControlD = np.array([0, 1, 0, 0], dtype=bool)
        RegWriteD = True
        ALUSrcD = True

    if (OpD == np.array([0, 0, 1, 1, 0, 0], dtype=bool)).all():
        # OPCODE_ANDI
        ALUControlD = np.array([0, 0, 1, 0], dtype=bool)
        RegWriteD = True
        ALUSrcD = True

    if (OpD == np.array([0, 0, 1, 0, 1, 0], dtype=bool)).all():
        # OPCODE_SLTI
        ALUControlD = np.array([0, 1, 1, 0], dtype=bool)
        RegWriteD = True
        ALUSrcD = True
        SignExtD = True

    if (OpD == np.array([0, 0, 0, 0, 1, 0], dtype=bool)).all():
        # OPCODE_J
        JumpD = True
        PCSrcD = True

    if (OpD == np.array([0, 0, 0, 0, 1, 1], dtype=bool)).all():
        # OPCODE_JAL
        PCSrcD = True
        JumpD = True
        RegWriteD = True
        RegDstD = np.array([1, 0], dtype=bool)
        MemtoRegD = np.array([1, 0], dtype=bool)

    if (OpD == np.array([0, 0, 0, 1, 0, 0], dtype=bool)).all():
        # OPCODE_BEQ
        BranchD = True

    if (OpD == np.array([0, 0, 0, 1, 0, 1], dtype=bool)).all():
        # OPCODE_BNE
        BranchD = True

    # Sign Extend logic
    SignImmD = np.zeros(32, dtype=bool)
    Extender = mux(0, immDecode[0], SignExtD)
    SignImmD[16:] = immDecode
    SignImmD[:16] = Extender

    # Hazard unit logic
    stall = MemReadEnE and (np.array_equal(WriteRegE, RsD) or np.array_equal(WriteRegE, RtD)) and np.any(WriteRegE)
    wrongPrediction = (predictionE != xnorOut) and BranchE
    flush = wrongPrediction or PCSrcD


    # ----------------------------------------- Fetch Stage---------------------------------------
    instrF = instructionMemory.process(PCF)

    # Halting logic. Programs are halted in the fourth cycle of consecutive NOP fetching, as then the latest non-NOP instruction will have reached the writeback stage
    if not stopExecuting:
        if np.all(np.logical_not(instrF)):
            stopExecuting = True
    else:
        if not np.all(np.logical_not(instrF)):
            countDown = 3
            stopExecuting = False
        else:
            countDown -= 1


    # Mini control unit, to know whether the fetched instruction is a branch one that needs to consider the predicted behavior
    OpF = slice(instrF, 31, 26)
    branchF = False
    if (OpF == np.array([0, 0, 0, 1, 0, 0], dtype=bool)).all() or (OpF == np.array([0, 0, 0, 1, 0, 1], dtype=bool)).all():
        # If the instruction is either a BEQ or a BNE
        branchF = True
    
    # PC calculation logic
    one = np.zeros(6, dtype=bool)
    one[-1] = 1
    PCPlusF = addition(PCF, one)
    PCBranchF = addition(PCPlusF, slice(instrF, 5, 0))
    
    # gshare branch prediction unit
    predictionF = False
    gshareIndex = bitsToNum(np.logical_xor(PCF, globalHistory))
    if globalHistory[-1]:
        if notTakenCounter[gshareIndex] < 2:
            predictionF = False
        else:
            predictionF = True
    else:
        if takenCounter[gshareIndex] >= 2:
            predictionF = True
        else:
            predictionF = False
    
    # PC selection logic that considers what type of instruction we have, what the branch prediction unit predicts to happen, whether a wrong prediction was detected,
    # whether the instruction is a jump instruction and what type of jump instruction it is
    pcPredictedF = mux(PCPlusF, PCBranchF, predictionF and branchF)
    pcCorrected = mux(PCPlusE, PCBranchE, not predictionE)
    pcFinal = mux(pcPredictedF, pcCorrected, wrongPrediction)
    jumpTypeMuxOut = mux(slice(RD1D, 5, 0), slice(immDecode, 5, 0), JumpD)
    pcSrcDMuxOut = mux(pcFinal, jumpTypeMuxOut, PCSrcD and not wrongPrediction)

    # Writing into branch prediction data structures
    gshareIndexUpdate = bitsToNum(np.logical_xor(PCE, globalHistory))
    if BranchE:
        if xnorOut:
            if globalHistory[-1]:
                takenCounter[gshareIndexUpdate] = min(takenCounter[gshareIndexUpdate]+1, 3)
            else:
                notTakenCounter[gshareIndexUpdate] = max(notTakenCounter[gshareIndexUpdate]-1, 0)
        else:
            if globalHistory[-1]:
                takenCounter[gshareIndexUpdate] = max(takenCounter[gshareIndexUpdate]-1, 0)
            else:
                notTakenCounter[gshareIndexUpdate] = min(notTakenCounter[gshareIndexUpdate]+1, 3)
        globalHistory = np.roll(globalHistory, -1)
        globalHistory[-1] = xnorOut
    
    
    # Writing all non-gp registers. Having the writing happen here instead of mid-loop is a necessity in a clock-less, sequential program to
    # simulate the behavior of the edge-activated writing of registers
    if not stall:
        registers["PC"] = pcSrcDMuxOut

    for pipe, pipeRegisters in pipelineRegisters.items():
        if (pipe == "IF / ID" and flush) or (pipe == "ID / EX" and (flush or stall)):
            # Zeroing the outputs of these registers by deleting them from the dictionary, thereby reverting to the default, zero values
            for reg, length in pipeRegisters:
                registers.pop(reg, None)
            continue
        if pipe == "IF / ID" and stall:
            # Not modifying the values is equivalent to connecting the inputs of the registers to their outputs in the structural program, holding their values
            continue
        for reg, length in pipeRegisters:
            # Pipe registers are normally assigned to the variable with the same name in the previous stage
            registers[reg] = eval(reg[:-1])
    
    # Storing the memory information for the current cycle in the run directory
    cycleStr = '{:05d}'.format(cycle)
    gpRegisters.store(cycleStr)
    dataMemory.store(cycleStr)
    with open(os.path.join(runDirectory, f'{cycleStr}registers.pkl'), 'wb') as f:
        pickle.dump(registers, f)

    # Printing whatever signals deemed useful for debugging/performance analysis purposes
    signals = ("PCF", "predictionF", "wrongPrediction", "flush", "stall", "ALUOutM")
    if signals:
        print(f"{'-' * 30} Cycle {cycle} {'-' * 30}")
        for signalName in signals:
            print(f"\t{signalName} has a value of:", end='\n\t\t')
            signal = eval(signalName)
            if type(signal) == np.ndarray:
                humanReadable(signal)
                print(f"\t\t↳ Corresponding to {bitsToNum(signal)} in decimal")
            else:
                print(signal)
    cycle += 1

    # Counting each non-NOP instruction encountered, correcting for flushes and stalls
    if np.any(PCF):
        instructions += 1
    if stall and not flush:
        instructions -= 1
    elif flush:
        instructions -= 2

CPI = '{:02.2f}'.format(cycle / instructions)
print(f"{'-' * 72}")
print(f"Execution finished in {cycle} cycles, with a CPI of {CPI}")
print(f"Data structures during every cycle have been stored in {runDirectory}")
