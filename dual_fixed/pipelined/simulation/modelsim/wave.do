onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate /testbench/PC
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
add wave -noupdate -radix binary /testbench/uut/nextPC
add wave -noupdate /testbench/uut/PCPlus1
add wave -noupdate /testbench/uut/rs
add wave -noupdate /testbench/uut/rt
add wave -noupdate /testbench/uut/rd
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
add wave -noupdate /testbench/uut/jump_r_address
add wave -noupdate /testbench/uut/adderResult
add wave -noupdate /testbench/uut/shamt
add wave -noupdate /testbench/uut/RF/readRegister1
add wave -noupdate /testbench/uut/RF/readRegister2
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/uut/RF/registers[31]} -radix hexadecimal} {{/testbench/uut/RF/registers[30]} -radix hexadecimal} {{/testbench/uut/RF/registers[29]} -radix hexadecimal} {{/testbench/uut/RF/registers[28]} -radix hexadecimal} {{/testbench/uut/RF/registers[27]} -radix hexadecimal} {{/testbench/uut/RF/registers[26]} -radix hexadecimal} {{/testbench/uut/RF/registers[25]} -radix hexadecimal} {{/testbench/uut/RF/registers[24]} -radix hexadecimal} {{/testbench/uut/RF/registers[23]} -radix hexadecimal} {{/testbench/uut/RF/registers[22]} -radix hexadecimal} {{/testbench/uut/RF/registers[21]} -radix hexadecimal} {{/testbench/uut/RF/registers[20]} -radix hexadecimal} {{/testbench/uut/RF/registers[19]} -radix hexadecimal} {{/testbench/uut/RF/registers[18]} -radix hexadecimal} {{/testbench/uut/RF/registers[17]} -radix hexadecimal} {{/testbench/uut/RF/registers[16]} -radix hexadecimal} {{/testbench/uut/RF/registers[15]} -radix hexadecimal} {{/testbench/uut/RF/registers[14]} -radix hexadecimal} {{/testbench/uut/RF/registers[13]} -radix hexadecimal} {{/testbench/uut/RF/registers[12]} -radix hexadecimal} {{/testbench/uut/RF/registers[11]} -radix hexadecimal} {{/testbench/uut/RF/registers[10]} -radix hexadecimal} {{/testbench/uut/RF/registers[9]} -radix hexadecimal} {{/testbench/uut/RF/registers[8]} -radix hexadecimal} {{/testbench/uut/RF/registers[7]} -radix hexadecimal} {{/testbench/uut/RF/registers[6]} -radix hexadecimal} {{/testbench/uut/RF/registers[5]} -radix hexadecimal} {{/testbench/uut/RF/registers[4]} -radix hexadecimal} {{/testbench/uut/RF/registers[3]} -radix hexadecimal} {{/testbench/uut/RF/registers[2]} -radix hexadecimal} {{/testbench/uut/RF/registers[1]} -radix hexadecimal} {{/testbench/uut/RF/registers[0]} -radix hexadecimal}} -subitemconfig {{/testbench/uut/RF/registers[31]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[30]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[29]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[28]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[27]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[26]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[25]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[24]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[23]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[22]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[21]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[20]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[19]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[18]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[17]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[16]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[15]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[14]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[13]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[12]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[11]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[10]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[9]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[8]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[7]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[6]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[5]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[4]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[3]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[2]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[1]} {-height 15 -radix hexadecimal} {/testbench/uut/RF/registers[0]} {-height 15 -radix hexadecimal}} /testbench/uut/RF/registers
add wave -noupdate /testbench/uut/PCsrc
add wave -noupdate /testbench/uut/memory_out_of_bound
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8123 ps} 0}
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
