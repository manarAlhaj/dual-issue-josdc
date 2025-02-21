# Initializes the instruction memory, and optionally the data memory, according to text files in the init folder

import numpy as np
import time
import os

INSTRUCTIONMEMORYSIZE = 2**6
DATAMEMORYSIZE = 2**6

currentDirectory = os.getcwd()
initDirectory = os.path.join(currentDirectory, 'init')

instructionsFile = os.path.join(initDirectory, 'instructions.txt') 
if os.path.exists(instructionsFile):
    with open(instructionsFile, "r") as f:
        lines = f.readlines()
else:
    print("Provide instructions file")
    exit()

lines = [line.strip() for line in lines if line.strip()]
instructionMemory = np.zeros((INSTRUCTIONMEMORYSIZE, 32), dtype=bool)
for instruction in range(len(lines)):
    for bit in range(32):
        instructionMemory[instruction][bit] = lines[instruction][bit] == '1'
np.save(os.path.join(initDirectory, 'instructionMemory.npy'), instructionMemory)

dataMemory = np.zeros((DATAMEMORYSIZE, 32), dtype=bool)
dataFile = os.path.join(initDirectory, 'dataMemory.txt')

if os.path.exists(dataFile):
    with open(dataFile, "r") as f:
        lines = f.readlines()
    lines = [line.split(':') for line in lines if line.strip()]
    dataEntries = [(int(line[0].strip()), line[1].strip()[:-1]) for line in lines]
    for address, data in dataEntries:
        for bit in range(32):
            dataMemory[address][bit] = data[bit] == '1'
    np.save(os.path.join(initDirectory, 'dataMemory.npy'), dataMemory)
