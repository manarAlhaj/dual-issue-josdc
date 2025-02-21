# A cycle accurate simulator for a 5-stage pipelined dual-issue static superscalar MIPS processor

import numpy as np
import pickle
import time
import os
import random

INSTRUCTIONMEMORYSIZE = 2**8
DATAMEMORYSIZE = 2**11
CLOCKFREQ = 85e6
counter = 0
storeEveryCycle = True
timeStr = str(int(time.time()))
currentDirectory = os.path.dirname(__file__)
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
        readData1 = np.zeros((2, 32), dtype=bool)
        readData2 = np.zeros((2, 32), dtype=bool)
        for i in range(2):
            target = bitsToNum(writeRegister[i])
            #  or (target == 31 and not JumpW[i][0])
            if regWrite[i][0] and not (target == 0):
                self.structure[target] = writeData[i]
        
        for i in range(2):
            readData1[i] = self.access(bitsToNum(readRegister1[i]))
            readData2[i] = self.access(bitsToNum(readRegister2[i]))
        
        return readData1, readData2
    
    def store(self, cycleStr):
        filepath = os.path.join(runDirectory, f'{cycleStr}gpregisters.npy')
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
    
    def checkEnd(self, address):
        # checks if there are any non-nop instructions from the given address to the end of the instruction memory
        addy = bitsToNum(address)
        if not np.any(self.structure[addy:]):
            return True
        return False


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
        # TODO: edit to perfectly mimick the verilog data memory
        readData = np.zeros((2, 32), dtype=bool)
        for i in range(2):
            addy = bitsToNum(address[i])
            if memWrite[i][0]:
                self.structure[addy] = writeData[i]
            if memRead[i][0]:
                readData[i] = self.access(addy)

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
[("instrFD", 32), ("PCPlusFD", 8), ("PCFD", 8), ("PCBranchFD", 8), ("predictionFD", 1)],
"ID / EX":
[('RdDE', 5), ('RtDE', 5), ('RsDE', 5), ('SignImmDE', 32), ('RD1DE', 32), ('RD2DE', 32), ("RegWriteDE", 1), ("MemtoRegDE", 2), ("MemWriteDE", 1),
 ("ALUControlDE", 4), ("ALUSrcDE", 1), ("RegDstDE", 2), ("BranchDE", 1), ("shamtDE", 5), ("PCPlusDE", 8), ("MemReadEnDE", 1), ("bit26DE", 1),
 ("PCBranchDE", 8), ("PCDE", 8), ("predictionDE", 1), ("WriteRegDE", 5), ("JumpDE", 1), ("instrDE", 32), ("PCDE", 8)],
"EX / MEM":
[("ALUOutEM", 32), ("WriteDataEM", 32), ("RegWriteEM", 1), ("MemtoRegEM", 2), ("MemWriteEM", 1), ("WriteRegEM", 5),
 ("PCPlusEM", 8), ("MemReadEnEM", 1), ("JumpEM", 1), ("instrEM", 32), ("PCEM", 8)],
"MEM / WB":
[("ReadDataMW", 32), ("ALUOutMW", 32), ("MemtoRegMW", 2), ("RegWriteMW", 1), ("PCPlusMW", 8), ("WriteRegMW", 5), ("JumpMW", 1), ("instrMW", 32), ("PCMW", 8)]
}


# BPU data structures initializations
takenCounter = np.zeros(64, dtype=int)
takenCounter[:] = 1
notTakenCounter = np.zeros(64, dtype=int)
notTakenCounter[:] = 2
globalHistory = np.zeros(6, dtype=bool)


# Cycle and instruction counters, for performance calculations
cycle = 0
instructions = 0

while True:
    # Reading the registers, which will either be
    defaultPC = np.zeros((2, 8), dtype=bool)
    defaultPC[1][-1] = 1
    PCF = registers.get('PC', defaultPC)

    instrD = registers.get('instrFD', np.zeros((2, 32), dtype=bool))
    PCPlusD = registers.get('PCPlusFD', np.zeros((2, 8), dtype=bool))
    PCD = registers.get('PCFD', np.zeros((2, 8), dtype=bool))
    PCBranchD = registers.get('PCBranchFD', np.zeros((2, 8), dtype=bool))
    predictionD = registers.get('predictionFD', np.zeros((2, 1), dtype=bool))

    RdE = registers.get('RdDE', np.zeros((2, 5), dtype=bool))
    RtE = registers.get('RtDE', np.zeros((2, 5), dtype=bool))
    RsE = registers.get('RsDE', np.zeros((2, 5), dtype=bool))
    SignImmE = registers.get('SignImmDE', np.zeros((2, 32), dtype=bool))
    RD1E = registers.get('RD1DE', np.zeros((2, 32), dtype=bool))
    RD2E = registers.get('RD2DE', np.zeros((2, 32), dtype=bool))
    RegWriteE = registers.get('RegWriteDE', np.zeros((2, 1), dtype=bool))
    MemtoRegE = registers.get('MemtoRegDE', np.zeros((2, 2), dtype=bool))
    MemWriteE = registers.get('MemWriteDE', np.zeros((2, 1), dtype=bool))
    ALUControlE = registers.get('ALUControlDE', np.zeros((2, 4), dtype=bool))
    ALUSrcE = registers.get('ALUSrcDE', np.zeros((2, 1), dtype=bool))
    RegDstE = registers.get('RegDstDE', np.zeros((2, 2), dtype=bool))
    BranchE = registers.get('BranchDE', np.zeros((2, 1), dtype=bool))
    shamtE = registers.get('shamtDE', np.zeros((2, 5), dtype=bool))
    PCPlusE = registers.get('PCPlusDE', np.zeros((2, 8), dtype=bool))
    MemReadEnE = registers.get('MemReadEnDE', np.zeros((2, 1), dtype=bool))
    bit26E = registers.get('bit26DE', np.zeros((2, 1), dtype=bool))
    PCBranchE = registers.get('PCBranchDE', np.zeros((2, 8), dtype=bool))
    predictionE = registers.get('predictionDE', np.zeros((2, 1), dtype=bool))
    PCE = registers.get('PCDE', np.zeros((2, 8), dtype=bool))
    WriteRegE = registers.get('WriteRegDE', np.zeros((2, 5), dtype=bool))
    JumpE = registers.get('JumpDE', np.zeros((2, 1), dtype=bool))
    instrE = registers.get('instrDE', np.zeros((2, 32), dtype=bool))

    ALUOutM = registers.get('ALUOutEM', np.zeros((2, 32), dtype=bool))
    WriteDataM = registers.get('WriteDataEM', np.zeros((2, 32), dtype=bool))
    RegWriteM = registers.get('RegWriteEM', np.zeros((2, 1), dtype=bool))
    MemtoRegM = registers.get('MemtoRegEM', np.zeros((2, 2), dtype=bool))
    MemWriteM = registers.get('MemWriteEM', np.zeros((2, 1), dtype=bool))
    WriteRegM = registers.get('WriteRegEM', np.zeros((2, 5), dtype=bool))
    PCPlusM = registers.get('PCPlusEM', np.zeros((2, 8), dtype=bool))
    MemReadEnM = registers.get('MemReadEnEM', np.zeros((2, 1), dtype=bool))
    JumpM = registers.get('JumpEM', np.zeros((2, 1), dtype=bool))
    instrM = registers.get('instrEM', np.zeros((2, 32), dtype=bool))
    PCM = registers.get('PCEM', np.zeros((2, 8), dtype=bool))

    ReadDataW = registers.get('ReadDataMW', np.zeros((2, 32), dtype=bool))
    ALUOutW = registers.get('ALUOutMW', np.zeros((2, 32), dtype=bool))
    MemtoRegW = registers.get('MemtoRegMW', np.zeros((2, 2), dtype=bool))
    RegWriteW = registers.get('RegWriteMW', np.zeros((2, 1), dtype=bool))
    PCPlusW = registers.get('PCPlusMW', np.zeros((2, 8), dtype=bool))
    WriteRegW = registers.get('WriteRegMW', np.zeros((2, 5), dtype=bool))
    JumpW = registers.get('JumpMW', np.zeros((2, 1), dtype=bool))
    instrW = registers.get('instrMW', np.zeros((2, 32), dtype=bool))
    PCW = registers.get('PCMW', np.zeros((2, 8), dtype=bool))
    

    # The order of the stages was reversed for sequential necessity; to make sure the values passed back to earlier stages are updated when called
    # ----------------------------------------- Writeback Stage ---------------------------------------
    ResultW = np.zeros((2, 32), dtype=bool)
    extendedPC = np.zeros((2, 32), dtype=bool)
    extendedPC[:, -8:] = PCPlusW
    for i in range(2):
        ResultW[i] = mux(ALUOutW[i], ReadDataW[i], extendedPC[i], MemtoRegW[i])
    RegWriteNewW = RegWriteW.copy()
    if (RegWriteW[0][0] and RegWriteW[1][0]) and np.any(WriteRegW[0]) and np.array_equal(WriteRegW[0], WriteRegW[1]):
        RegWriteNewW[0][0] = 0

    # ----------------------------------------- Memory Stage ---------------------------------------
    address = np.zeros((2, 11), dtype=bool)
    for i in range(2):
        address[i] = slice(ALUOutM[i], 10, 0)
    ReadDataM = dataMemory.process(address=address, writeData=WriteDataM, memWrite=MemWriteM, memRead=MemReadEnM)


    # ----------------------------------------- Execute Stage ---------------------------------------

    # Forwarding unit
    ForwardA = np.zeros((2, 3), dtype=bool)
    ForwardB = np.zeros((2, 3), dtype=bool)
    for i in range(2):
        # Priority of if-statements are lowest to highest, as the bottom if-statement has top priority
        if RegWriteW[0][0] and np.any(WriteRegW[0]):
            if np.array_equal(WriteRegW[0], RsE[i]):
                ForwardA[i] = (0, 1, 1)
            if np.array_equal(WriteRegW[0], RtE[i]):
                ForwardB[i] = (0, 1, 1)
        if RegWriteW[1][0] and np.any(WriteRegW[1]):
            if np.array_equal(WriteRegW[1], RsE[i]):
                ForwardA[i] = (1, 0, 0)
            if np.array_equal(WriteRegW[1], RtE[i]):
                ForwardB[i] = (1, 0, 0)
        if RegWriteM[0][0] and np.any(WriteRegM[0]):
            if np.array_equal(WriteRegM[0], RsE[i]):
                ForwardA[i] = (0, 0, 1)
            if np.array_equal(WriteRegM[0], RtE[i]):
                ForwardB[i] = (0, 0, 1)
        if RegWriteM[1][0] and np.any(WriteRegM[1]):
            if np.array_equal(WriteRegM[1], RsE[i]):
                ForwardA[i] = (0, 1, 0)
            if np.array_equal(WriteRegM[1], RtE[i]):
                ForwardB[i] = (0, 1, 0)

    # ALU input processing logic
    SrcAE = np.zeros((2, 32), dtype=bool)
    WriteDataE = np.zeros((2, 32), dtype=bool)
    SrcBE = np.zeros((2, 32), dtype=bool)
    for i in range(2):
        SrcAE[i] = mux(RD1E[i], ALUOutM[0], ALUOutM[1], ResultW[0], ResultW[1], ForwardA[i])
        WriteDataE[i] = mux(RD2E[i], ALUOutM[0], ALUOutM[1], ResultW[0], ResultW[1], ForwardB[i])
        SrcBE[i] = mux(WriteDataE[i], SignImmE[i], ALUSrcE[i])

    # Branch equality checks
    actualOutcome = np.zeros((2, 1), dtype=bool)
    for i in range(2):
        equalE = np.array_equal(SrcAE[i], WriteDataE[i])
        xnorOut = not equalE == bit26E[i][0]
        actualOutcome[i][0] = xnorOut and BranchE[i][0]
    
    # ALU logic
    ALUOutE = np.zeros((2, 32), dtype=bool)
    zeroFlagE = np.zeros((2, 1), dtype=bool)
    OVFE = np.zeros((2, 1), dtype=bool)
    MemoryOoBE = np.zeros((2, 1), dtype=bool)
    for i in range(2):
        ALUOpE = bitsToNum(ALUControlE[i])
        if ALUOpE == 0:
            ALUOutE[i] = addition(SrcAE[i], SrcBE[i])
        elif ALUOpE == 1:
            ALUOutE[i] = subtraction(SrcAE[i], SrcBE[i])
        elif ALUOpE == 2:
            ALUOutE[i] = np.logical_and(SrcAE[i], SrcBE[i])
        elif ALUOpE == 3:
            ALUOutE[i] = np.logical_or(SrcAE[i], SrcBE[i])
        elif ALUOpE == 4:
            ALUOutE[i] = np.logical_xor(SrcAE[i], SrcBE[i])
        elif ALUOpE == 5:
            # NOR
            ALUOutE[i] = np.logical_not(np.logical_or(SrcAE[i], SrcBE[i]))
        elif ALUOpE == 6:
            # SLT
            ALUOutE[i][-1] = bitsToNumSigned(SrcAE[i]) < bitsToNumSigned(SrcBE[i])
        elif ALUOpE == 7:
            # Shift left
            shiftVal = bitsToNum(shamtE[i])
            ALUOutE[i] = np.roll(SrcBE[i], -shiftVal)
            ALUOutE[i][-shiftVal:] = 0
        elif ALUOpE == 8:
            # Shift right
            shiftVal = bitsToNum(shamtE[i])
            ALUOutE[i] = np.roll(SrcBE[i], shiftVal)
            ALUOutE[i][: shiftVal] = 0
        elif ALUOpE == 9:
            # SGT
            ALUOutE[i][-1] = bitsToNumSigned(SrcAE[i]) > bitsToNumSigned(SrcBE[i])

        # ALU flags calculation
        zeroFlagE[i] = not np.any(ALUOutE[i])
        OVFE[i] = (ALUOutE[i][0] and not SrcAE[i][0] and not SrcBE[i][0]) or (not ALUOutE[i][0] and SrcAE[i][0] and SrcBE[i][0])
        addy = bitsToNumSigned(addition(SrcAE[i], SrcBE[i]))
        MemoryOoBE[i] = (addy > 255) or (addy < 0)


    # ----------------------------------------- Decode Stage ---------------------------------------
    RdD = np.zeros((2, 5), dtype=bool)
    RtD = np.zeros((2, 5), dtype=bool)
    RsD = np.zeros((2, 5), dtype=bool)
    shamtD = np.zeros((2, 5), dtype=bool)
    immDecode = np.zeros((2, 16), dtype=bool)
    bit26D = np.zeros((2, 1), dtype=bool)
    for i in range(2):
        RdD[i] = slice(instrD[i], 15, 11)
        RtD[i] = slice(instrD[i], 20, 16)
        RsD[i] = slice(instrD[i], 25, 21)
        shamtD[i] = slice(instrD[i], 10, 6)
        immDecode[i] = slice(instrD[i], 15, 0)
        bit26D[i] = slice(instrD[i], 26)

    RD1D, RD2D = gpRegisters.process(readRegister1=RsD, readRegister2=RtD, writeRegister=WriteRegW, writeData=ResultW, regWrite=RegWriteNewW)

    # Control unit logic
    OpD = np.zeros((2, 6), dtype=bool)
    FunctD = np.zeros((2, 6), dtype=bool)
    RegDstD = np.zeros((2, 2), dtype=bool)
    BranchD = np.zeros((2, 1), dtype=bool)
    MemReadEnD = np.zeros((2, 1), dtype=bool)
    MemtoRegD = np.zeros((2, 2), dtype=bool)
    MemWriteD = np.zeros((2, 1), dtype=bool)
    RegWriteD = np.zeros((2, 1), dtype=bool)
    ALUSrcD = np.zeros((2, 1), dtype=bool)
    JumpD = np.zeros((2, 1), dtype=bool)
    PCSrcD = np.zeros((2, 1), dtype=bool)
    ALUControlD = np.zeros((2, 4), dtype=bool)
    SignExtD = np.zeros((2, 1), dtype=bool)
    for i in range(2):
        OpD = slice(instrD[i], 31, 26)
        FunctD = slice(instrD[i], 5, 0)

        if (OpD == np.array([0, 0, 0, 0, 0, 0], dtype=bool)).all():
            # OPCODE_R_TYPE
            RegDstD[i] = np.array([0, 1], dtype=bool)
            RegWriteD[i] = True
            if (FunctD == np.array([1, 0, 0, 0, 0, 0], dtype=bool)).all():
                # ADD
                ALUControlD[i] = np.array([0, 0, 0, 0], dtype=bool)
            if (FunctD == np.array([1, 0, 0, 0, 1, 0], dtype=bool)).all():
                # SUB
                ALUControlD[i] = np.array([0, 0, 0, 1], dtype=bool)
            if (FunctD == np.array([1, 0, 0, 1, 0, 0], dtype=bool)).all():
                # AND
                ALUControlD[i] = np.array([0, 0, 1, 0], dtype=bool)
            if (FunctD == np.array([1, 0, 0, 1, 0, 1], dtype=bool)).all():
                # OR
                ALUControlD[i] = np.array([0, 0, 1, 1], dtype=bool)
            if (FunctD == np.array([1, 0, 0, 1, 1, 0], dtype=bool)).all():
                # XOR
                ALUControlD[i] = np.array([0, 1, 0, 0], dtype=bool)
            if (FunctD == np.array([1, 0, 0, 1, 1, 1], dtype=bool)).all():
                # NOR
                ALUControlD[i] = np.array([0, 1, 0, 1], dtype=bool)
            if (FunctD == np.array([1, 0, 1, 0, 1, 0], dtype=bool)).all():
                # SLT
                ALUControlD[i] = np.array([0, 1, 1, 0], dtype=bool)
            if (FunctD == np.array([0, 0, 0, 0, 0, 0], dtype=bool)).all():
                # SLL
                ALUControlD[i] = np.array([0, 1, 1, 1], dtype=bool)
            if (FunctD == np.array([0, 0, 0, 0, 1, 0], dtype=bool)).all():
                # SRL
                ALUControlD[i] = np.array([1, 0, 0, 0], dtype=bool)
            if (FunctD == np.array([1, 0, 1, 0, 1, 1], dtype=bool)).all():
                # SGT
                ALUControlD[i] = np.array([1, 0, 0, 1], dtype=bool)
            if (FunctD == np.array([0, 0, 1, 0, 0, 0], dtype=bool)).all():
                # JR
                PCSrcD[i] = True
        
        if (OpD == np.array([1, 0, 0, 0, 1, 1], dtype=bool)).all():
            # OPCODE_LW
            MemReadEnD[i] = True
            MemtoRegD[i] = np.array([0, 1], dtype=bool)
            RegWriteD[i] = True
            ALUSrcD[i] = True

        if (OpD == np.array([1, 0, 1, 0, 1, 1], dtype=bool)).all():
            # OPCODE_SW
            MemWriteD[i] = True
            ALUSrcD[i] = True

        if (OpD == np.array([0, 0, 1, 0, 0, 0], dtype=bool)).all():
            # OPCODE_ADDI
            RegWriteD[i] = True
            ALUSrcD[i] = True
            SignExtD[i] = True

        if (OpD == np.array([0, 0, 1, 1, 0, 1], dtype=bool)).all():
            # OPCODE_ORI
            ALUControlD[i] = np.array([0, 0, 1, 1], dtype=bool)
            RegWriteD[i] = True
            ALUSrcD[i] = True

        if (OpD == np.array([0, 0, 1, 1, 1, 0], dtype=bool)).all():
            # OPCODE_XORI
            ALUControlD[i] = np.array([0, 1, 0, 0], dtype=bool)
            RegWriteD[i] = True
            ALUSrcD[i] = True

        if (OpD == np.array([0, 0, 1, 1, 0, 0], dtype=bool)).all():
            # OPCODE_ANDI
            ALUControlD[i] = np.array([0, 0, 1, 0], dtype=bool)
            RegWriteD[i] = True
            ALUSrcD[i] = True

        if (OpD == np.array([0, 0, 1, 0, 1, 0], dtype=bool)).all():
            # OPCODE_SLTI
            ALUControlD[i] = np.array([0, 1, 1, 0], dtype=bool)
            RegWriteD[i] = True
            ALUSrcD[i] = True
            SignExtD[i] = True

        if (OpD == np.array([0, 0, 0, 0, 1, 0], dtype=bool)).all():
            # OPCODE_J
            JumpD[i] = True
            PCSrcD[i] = True

        if (OpD == np.array([0, 0, 0, 0, 1, 1], dtype=bool)).all():
            # OPCODE_JAL
            PCSrcD[i] = True
            JumpD[i] = True
            RegWriteD[i] = True
            RegDstD[i] = np.array([1, 0], dtype=bool)
            MemtoRegD[i] = np.array([1, 0], dtype=bool)

        if (OpD == np.array([0, 0, 0, 1, 0, 0], dtype=bool)).all():
            # OPCODE_BEQ
            BranchD[i] = True

        if (OpD == np.array([0, 0, 0, 1, 0, 1], dtype=bool)).all():
            # OPCODE_BNE
            BranchD[i] = True


    WriteRegD = np.zeros((2, 5), dtype=bool)
    for i in range(2):
        WriteRegD[i] = mux(RtD[i], RdD[i], np.ones(5, dtype=bool), RegDstD[i])
    jumpRegisterD = np.zeros((2, 1), dtype=bool)
    for i in range(2):
        jumpRegisterD[i] = PCSrcD[i] and not JumpD[i]
    
    innerDependency = False
    if (RegWriteD[0][0] and np.any(WriteRegD[0]) and not (jumpRegisterD[1][0] or JumpD[1][0]) and 
        ((np.array_equal(WriteRegD[0], RsD[1])) or (not ALUSrcD[1][0] and np.array_equal(WriteRegD[0], RtD[1])))):
        # In case the top lane instruction writes something that the bottom lane instruction reads
        innerDependency = True
    if BranchD[0][0] and (jumpRegisterD[1][0] or JumpD[1][0]):
        # In case we have a branch on the top lane and a jump on the bottom lane
        innerDependency = True

    # Sign Extend logic
    SignImmD = np.zeros((2, 32), dtype=bool)
    for i in range(2):
        Extender = mux(0, immDecode[i][0], SignExtD[i])
        SignImmD[i][16:] = immDecode[i]
        SignImmD[i][:16] = Extender


    # ----------------------------------------- Fetch Stage---------------------------------------
    # PC calculation logic
    one = np.zeros(8, dtype=bool)
    one[-1] = 1
    two = np.zeros(8, dtype=bool)
    two[-2] = 1
    PCPlusOne = addition(PCF[0], one)
    PCPlusTwo = addition(PCF[0], two)
    PCPlusF = np.zeros((2, 8), dtype=bool)
    PCPlusF[0] = PCPlusOne
    PCPlusF[1] = addition(PCF[1], one)
    # PCPlusF[1] = PCPlusTwo

    instrF = np.zeros((2, 32), dtype=bool)
    instrF[0] = instructionMemory.process(PCF[0])
    instrF[1] = instructionMemory.process(PCF[1])

    # Mini control unit, to know whether the fetched instruction is a branch one that needs to consider the predicted behavior
    OpF = [slice(instrF[i], 31, 26) for i in range(2)]
    branchF = np.zeros((2, 1), dtype=bool)
    for i in range(2):
        if (OpF[i] == np.array([0, 0, 0, 1, 0, 0], dtype=bool)).all() or (OpF[i] == np.array([0, 0, 0, 1, 0, 1], dtype=bool)).all():
            # If the instruction is either a BEQ or a BNE
            branchF[i] = True
    twoBranches = branchF[0] and branchF[1]


    PCBranchF = np.zeros((2, 8), dtype=bool)
    PCBranchF[0] = addition(PCPlusOne, slice(instrF[0], 7, 0))
    PCBranchF[1] = addition(PCPlusTwo, slice(instrF[1], 7, 0))

    jumpTA = np.zeros((2, 8), dtype=bool)
    for i in range(2):
        jumpTA[i] = mux(slice(RD1D[i], 7, 0), slice(immDecode[i], 7, 0), JumpD[i])
    
    # gshare branch prediction unit
    # TODO: update the BPU
    predictionF = np.zeros((2, 1), dtype=bool)
    # predictionF[0][0] = 1
    # predictionF[1][0] = 1
    predictionF[0][0] = random.randint(0, 1)
    predictionF[1][0] = random.randint(0, 1)


    # PC selection logic and hazard detection logic
    # The flush signal consists of 8 bits; 2 bits for the two lanes of each of the 4 pipes
    flush = np.zeros((4, 2), dtype=bool)
    stall = False
    wrongPrediction1 = ((predictionE[0][0] != actualOutcome[0][0]) and BranchE[0][0])
    wrongPrediction2 = ((predictionE[1][0] != actualOutcome[1][0]) and BranchE[1][0])
    correctedPC = np.zeros((2, 8), dtype=bool)
    for i in range(2):
        correctedPC[i] = mux(PCBranchE[i], PCPlusE[i], predictionE[i])

    # We check if either of the two EXECUTE stage instructions are a load that either of the two DECODE stage instruction uses
    for i in range(2):
        for j in range(2):
            if (MemReadEnE[i][0] and (not (jumpRegisterD[j][0] or JumpD[j][0])) and
            (np.array_equal(WriteRegE[i], RsD[j]) or (not ALUSrcD[j][0] and np.array_equal(WriteRegE[i], RtD[j])) and np.any(WriteRegE[i]))):
                stall = True

    switchy = False
    stallFinal = False
    # The pipe registers and PC behavior is decided by this sequence of if-statements, in order of decreasing priority

    # Wrong predictions have the highest priorty, as they flush all instructions fetched after them
    if wrongPrediction1:
        flush[0:2, :] = 1
        flush[2, 1] = 1
        PCSelectedF = correctedPC[0]
    elif wrongPrediction2:
        flush[0:2, :] = 1
        PCSelectedF = correctedPC[1]
    
    # Stalls come in second, as a stall holds the F and D instructions and none of the conditions after it affect any later stage
    elif stall:
        PCSelectedF = PCF[0]
        stallFinal = True
    
    # Jumps are next in line, they flush the F stage and possible the other instruction in the same stage, changing the PC value to their jump target
    elif (jumpRegisterD[0][0] or JumpD[0][0]):
        PCSelectedF = jumpTA[0]
        flush[0, :] = 1
        flush[1, 1] = 1
    elif (jumpRegisterD[1][0] or JumpD[1][0]) and not BranchD[0][0]:
        PCSelectedF = jumpTA[1]
        flush[0, :] = 1
    
    # A dependency between the two instructions in the decode stage triggers special behavior in which the earlier instruction is propagated forwards
    # while the earlier one is help up, paired with the next instruction while maintaining correct, in-order execution
    elif innerDependency:
        if predictionF[0][0] and branchF[0][0]:
            PCSelectedF = PCBranchF[0]
        else:
            PCSelectedF = PCPlusOne
        flush[1, 1] = 1
        switchy = True
    
    # Fetched branches change the next PC fetched according to the output of the BPU
    elif predictionF[0][0] and branchF[0][0]:
        flush[0, 1] = 1
        PCSelectedF = PCBranchF[0]
    elif predictionF[1][0] and branchF[1][0]:
        PCSelectedF = PCBranchF[1]
    
    # If we have none of the earlier cases, we fetch the PC+2, which is the earliest non-fetched instruction
    else:
        PCSelectedF = PCPlusTwo
    
    # Writing into branch prediction data structures
    # TODO: edit into the new BPU structure
    
    # Halting logic. Programs are halted if all instructions in stages earlier than writeback are NOPs and there are no non-NOP instructions later in the instruction memory
    stopExecution = (not (np.any(instrF) or np.any(instrD) or np.any(instrE) or np.any(instrM))) and instructionMemory.checkEnd(PCSelectedF)
    
    # Writing all non-gp registers. Having the writing happen here instead of mid-loop is a necessity in a clock-less, sequential program to
    # simulate the behavior of the edge-activated writing of registers
    newPC = np.zeros((2, 8), dtype=bool)
    newPC[0] = PCSelectedF
    newPC[1] = addition(PCSelectedF, one)
    registers["PC"] = newPC

    for i, (pipe, pipeRegisters) in enumerate(pipelineRegisters.items()):
        if switchy and i==0:
            for reg, length in pipeRegisters:
                # Pipe registers are normally assigned to the variable with the same name in the previous stage
                varF = eval(reg[:-1])
                varD = eval(reg[:-2]+'D')
                var = np.zeros(shape=(2, varF.shape[1]), dtype=bool)
                var[0] = varD[1]
                var[1] = varF[0]
                registers[reg] = var
            continue
        if stallFinal:
            if i==0:
                continue
            if i==1:
                for reg, length in pipeRegisters:
                    registers.pop(reg, None)
                continue
        for reg, length in pipeRegisters:
            # Pipe registers are normally assigned to the variable with the same name in the previous stage
            var = np.array(eval(reg[:-1]))
            for j in range(2):
                if flush[i, j]:
                    var[j, :] = 0
            registers[reg] = var
    
    # Printing whatever signals deemed useful for debugging/performance analysis purposes
            #     if (MemReadEnE[i][0] and not (jumpRegisterD[j][0] or JumpD[j][0]) and
            # np.array_equal(WriteRegE[i], RsD[j]) or (not ALUSrcD[j][0] and np.array_equal(WriteRegE[i], RtD[j])) and np.any(WriteRegE[i][0])):
            
    signals = ("PCD", "PCE", "PCM", "PCW", "RegWriteNewW","WriteRegW", "ResultW")
    # signals = ("PCF", "PCD", "PCE", "address", "ReadDataM")
    print(f"{'-' * 30} Cycle {cycle} {'-' * 30}")
    if signals:
        for signalName in signals:
            print(f"\t{signalName} has a value of:", end='\n\t\t')
            signal = eval(signalName)
            if type(signal) == np.ndarray:
                if signal.ndim > 1:
                    for k in range(signal.shape[0]):
                        humanReadable(signal[k])
                        if k != signal.shape[0]-1:
                            e = '\n\t\t'
                        else:
                            e = '\n'
                        print(f"\t\t↳ Corresponding to {bitsToNum(signal[k])} in decimal", end=e)
                else:
                    humanReadable(signal)
                    print(f"\t\t↳ Corresponding to {bitsToNum(signal)} in decimal")
            else:
                print(signal)

    # Storing the memory information for the current cycle in the run directory
    if storeEveryCycle or stopExecution:
        cycleStr = '{:07d}'.format(cycle)
        gpRegisters.store(cycleStr)
        dataMemory.store(cycleStr)
        with open(os.path.join(runDirectory, f'{cycleStr}registers.pkl'), 'wb') as f:
            pickle.dump(registers, f)
    
    # Counting each non-NOP instruction encountered, correcting for flushes and stalls by only considering instructions that reach the writeback stage
    for i in range(2):
        if np.any(instrW[i]):
            instructions += 1
    cycle += 1
    
    if stopExecution:
        break

# Printing execution information
IPC = '{:02.2f}'.format(instructions / cycle)
print(f"{'-' * 72}")
print(f"The processor executed {instructions} instructions in {cycle} cycles, with a IPC of {IPC}")
freqFormatted = '{:02.1f}'.format(CLOCKFREQ / 1e6)
executionTime = '{:03.3f}'.format(cycle / CLOCKFREQ * 1e6)
print(f"Total execution time with a clock frequency of {freqFormatted} MHZ is {executionTime}µs")
print(f"Data structures during every cycle have been stored in {runDirectory}")
