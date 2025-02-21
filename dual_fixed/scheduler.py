# A scheduler for a static dual-issue superscalar processor

import numpy as np
import os

currentDirectory = os.getcwd()
initDirectory = os.path.join(currentDirectory, 'init')

# Instruction decoding and block identification
blocks = []
instructions = []
with open(os.path.join(initDirectory, 'code.txt')) as file:
    start = None
    current = -1
    for l in file:
        # TODO: Write more sophisticated line reading to account for comments
        line = l.strip().upper()
        if not line:
            continue
        elif line[-1] == ':':
            if start is not None:
                blocks.append((start, current))
                start = None
        else:
            # The current line is an instruction
            current += 1
            instructions.append(dict())
            instructions[current]['string'] = l
            if start is None:
                start = current
            
            # Instruction decode
            # TODO: complete the decode process
            line = line.replace(',', ' ')
            parts = [part.strip() for part in line.split()]
            print(parts)
            if parts[0] in ('BEQ', 'BNE'):
                instructions[current]['type'] = 'branch'
            elif parts[0] in ('J', 'JAL', 'JR'):
                instructions[current]['type'] = 'branch'
            elif parts[0] in ('ADD', 'SUB', 'AND', 'OR', 'XOR', 'NOR', 'SLT', 'SGT'):
                instructions[current]['type'] = 'operation'
                instructions[current]['savedReg'] = parts[1]
                instructions[current]['usedRegs'] = (parts[2], parts[3])
            elif parts[0] in ('ADDI', 'ORI', 'XORI', 'ANDI', 'SLTI', 'SLL', 'SRL'):
                instructions[current]['type'] = 'operation'
                instructions[current]['savedReg'] = parts[1]
                instructions[current]['usedRegs'] = (parts[2],)
            elif parts[0] == 'SW':
                instructions[current]['type'] = 'store'
            elif parts[0] == 'LW':
                instructions[current]['type'] = 'load'
            
            if instructions[current]['type'] == 'branch':
                blocks.append((start, current))
                start = None
    if start is not None:
        blocks.append((start, current))

# TODO: loop unrolling logic
pass

# A block is identified by a start and end index, we want to return an optimal reordering of the indices in between
for start, end in blocks:
    incoming = {i: dict() for i in range(start, end+1)}
    outgoing = {i: dict() for i in range(start, end+1)}
    criticalPath = dict()
    # Indicates if the block ends with a branch instruction, since a branch cannot be reordered within a block
    branchEnd = False

    for inst in range(start, end+1):
        if inst == end and instructions[inst]['type'] == 'branch':
            branchEnd = True
            break
        for earlierInst in range(inst-1, start-1, -1):
            if instructions[inst]['type'] == instructions[earlierInst]['type'] == 'branch':
                incoming[inst][earlierInst] = 1
                outgoing[earlierInst][inst] = 1
            if instructions[earlierInst]['savedReg'] in instructions[inst]['usedRegs']:
                incoming[inst][earlierInst] = 1+int(instructions[earlierInst]['type'] == 'load')
                outgoing[earlierInst][inst] = 1+int(instructions[earlierInst]['type'] == 'load')
            if instructions[earlierInst]['savedReg'] == instructions[inst]['savedReg']:
                incoming[inst][earlierInst] = 0
                outgoing[earlierInst][inst] = 0
    
    # Critical path calculation. groundTruths are nodes for which we have exhausted the possible paths to and are thus sure of their critical path value
    reachedTimes = dict()
    groundTruths = set()
    for inst in range(start, end+1):
        if len(incoming[inst]) == 0:
            criticalPath[inst] = 0
            groundTruths.add(inst)
    
    while len(groundTruths) > 0:
        node = groundTruths.pop()
        for previous in outgoing[node]:
            reachedTimes[previous] = reachedTimes.get(previous, 0) + 1
            criticalPath[previous] = max(criticalPath.get(previous, 0), criticalPath[node]+outgoing[node][previous])
            if reachedTimes[previous] == len(incoming[previous]):
                groundTruths.add(previous)

    timeStep = 0
    ordering = list()
    remaining = [i for i in range(start, end+1)]
    packets = []
    
    # An implicit assumption here is that the first instruction in a block is always the first instruction in a packet
    # This is not always true, but when it's not, we will either sync up to this case or run an equally efficient pairing of instructions
    while remaining:
        # Decrement/remove latencies from the last two dependencies, assuming a maximal latency of 2
        for packet in packets[-2:]:
            for instruction in packet:
                removalList, decrementList = [], []
                for inst, latency in outgoing[instruction].items():
                    if latency <= 1:
                        removalList.append(inst)
                    else:
                        decrementList.append(inst)
                for removal in removalList:
                    del incoming[removal][instruction]
                    del outgoing[instruction][removal]
                for decrem in decrementList:
                    incoming[decrem][instruction] -= 1
                    outgoing[instruction][decrem] -= 1
        packets.append(list())
        options = []
        for instruction in remaining:
            maximum = -1
            for nextInst, latency in outgoing[instruction].items():
                maximum = max(maximum, latency)
            if len(incoming[instruction]) == 0:
                options.append(((instruction,), maximum))
            elif len(incoming[instruction]) == 1 and next(iter(incoming[instruction].values())) == 0:
                options.append(((next(iter(incoming[instruction])), instruction), maximum))

        # Using the fact that python's sort is stable, we order our sorting calls in increasing importance, each call being a tiebreaker for the next;
        # We first sort by length of the sequence, favoring couples of instructions
        options.sort(key= lambda x: len(x[0]), reverse=True)
        # We favor instructions that will have a higher latency ahead of them
        options.sort(key= lambda x: x[1], reverse=True)
        # We ultimately choose instructions that have the highest critical path, as it represents the minimal possible amount of remaining packets
        options.sort(key= lambda x: max(criticalPath[node] for node in x[0]), reverse=True)

        for option in options:
            if len(packets[-1]) + len(option[0]) <= 2:
                for instruction in option[0]:
                    remaining.remove(instruction)
                    packets[-1].append(instruction)
            if len(packets[-1]) == 2:
                break
    if branchEnd:
        if len(packets[-1]) == 2:
            packets.append([end])
        else:
            packets[-1].append(end)

with open(os.path.join(initDirectory, 'rescheduler.txt'), 'w') as file:
    for packet in packets:
        for instruction in packet:
            instring = instructions[instruction]['string'].strip()
            file.write(instring+'\n')
