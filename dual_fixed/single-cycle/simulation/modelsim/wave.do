onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate -radix unsigned /testbench/PC
add wave -noupdate -radix unsigned /testbench/uut/nextPC
add wave -noupdate -radix hexadecimal /testbench/uut/instruction
add wave -noupdate -radix hexadecimal /testbench/uut/writeData
add wave -noupdate -radix hexadecimal /testbench/uut/readData1
add wave -noupdate -radix hexadecimal /testbench/uut/readData2
add wave -noupdate -radix hexadecimal /testbench/uut/extImm
add wave -noupdate -radix hexadecimal /testbench/uut/ALUin2
add wave -noupdate -radix hexadecimal /testbench/uut/ALUResult
add wave -noupdate -radix hexadecimal /testbench/uut/memoryReadData
add wave -noupdate -radix hexadecimal /testbench/uut/imm
add wave -noupdate -radix binary /testbench/uut/opCode
add wave -noupdate -radix binary /testbench/uut/funct
add wave -noupdate -radix unsigned /testbench/uut/rs
add wave -noupdate -radix unsigned /testbench/uut/rt
add wave -noupdate -radix unsigned /testbench/uut/rd
add wave -noupdate -radix unsigned /testbench/uut/writeRegister
add wave -noupdate /testbench/uut/ALUOp
add wave -noupdate -format Literal -radix decimal /testbench/uut/MemReadEn
add wave -noupdate -radix decimal /testbench/uut/MemtoReg
add wave -noupdate -format Literal -radix decimal /testbench/uut/MemWriteEn
add wave -noupdate -format Literal -radix decimal /testbench/uut/RegWriteEn
add wave -noupdate -format Literal -radix decimal /testbench/uut/ALUSrc
add wave -noupdate -format Literal -radix decimal /testbench/uut/zero
add wave -noupdate -format Literal -radix decimal /testbench/uut/JUMP
add wave -noupdate -format Literal -radix decimal /testbench/uut/sign_ext
add wave -noupdate -format Literal -radix decimal /testbench/uut/OVF
add wave -noupdate -format Literal -radix decimal /testbench/uut/BRANCH_SIG
add wave -noupdate -format Literal -radix decimal /testbench/uut/Branch_type
add wave -noupdate -format Literal -radix decimal /testbench/uut/Branch
add wave -noupdate /testbench/uut/RegDst
add wave -noupdate -radix unsigned /testbench/uut/jump_r_address
add wave -noupdate -radix unsigned /testbench/uut/adderResult
add wave -noupdate /testbench/uut/shamt
add wave -noupdate -radix unsigned /testbench/uut/RF/readRegister1
add wave -noupdate -radix unsigned /testbench/uut/RF/readRegister2
add wave -noupdate -format Literal -radix binary /testbench/uut/PCsrc
add wave -noupdate -format Literal -radix binary /testbench/uut/memory_out_of_bound
add wave -noupdate -radix hexadecimal /testbench/uut/RF/registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3477549 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 210
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {119700 ps}
