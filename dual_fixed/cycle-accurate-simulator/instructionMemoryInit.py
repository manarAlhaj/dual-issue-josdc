# A file that initializes the insturction memory given a string of machine code
import numpy as np
import os

INSTRUCTIONMEMORYSIZE = 2**6
currentDirectory = os.getcwd()
initDirectory = os.path.join(currentDirectory, 'init')

instructions = """
"""
instructions = instructions.split()
instructions = [instruction.strip() for instruction in instructions]
assert len(instructions) <= INSTRUCTIONMEMORYSIZE
for instruction in instructions:
    assert len(instruction) == 32
instructionMemory = np.zeros((INSTRUCTIONMEMORYSIZE, 32), dtype=bool)
for i, instruction in enumerate(instructions):
    instructionMemory[i] = np.array([bool(int(char)) for char in instruction[::-1]])