onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate -radix decimal /testbench/pcFetch
add wave -noupdate -divider instuctions
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Decode
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Decode
add wave -noupdate -divider RF
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[24]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[14]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[9]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[16]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[13]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[4]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[5]}
add wave -noupdate /testbench/uut/prediction_EX_1
add wave -noupdate /testbench/uut/prediction_EX_2
add wave -noupdate -divider PC
add wave -noupdate -radix decimal /testbench/uut/pcF_pipe
add wave -noupdate -radix decimal /testbench/uut/pcPlus1F_pipe
add wave -noupdate -radix decimal /testbench/uut/pcD
add wave -noupdate -radix unsigned /testbench/uut/pc_EX
add wave -noupdate -radix decimal /testbench/uut/PC
add wave -noupdate /testbench/uut/switchy
add wave -noupdate /testbench/uut/stall_inner
add wave -noupdate /testbench/uut/outer_depend
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst2_Fetch
add wave -noupdate -radix decimal /testbench/uut/pcPlus1D
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_WB
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_WB
add wave -noupdate /testbench/uut/flush_F_1
add wave -noupdate /testbench/uut/flush_F_2
add wave -noupdate /testbench/uut/flush_D_1
add wave -noupdate /testbench/uut/flush_D_2
add wave -noupdate /testbench/uut/flush_E_2
add wave -noupdate -divider prediction
add wave -noupdate /testbench/uut/predictionF_1
add wave -noupdate /testbench/uut/predictionF_2
add wave -noupdate /testbench/uut/equal_inst1
add wave -noupdate /testbench/uut/equal_inst2
add wave -noupdate -divider {FORWARDING UNIT}
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst2
add wave -noupdate /testbench/uut/FU/forwardA_inst1
add wave -noupdate /testbench/uut/FU/forwardB_inst1
add wave -noupdate /testbench/uut/FU/forwardA_inst2
add wave -noupdate /testbench/uut/FU/forwardB_inst2
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/op1
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/op2
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/result
add wave -noupdate -divider {ALU 2}
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op1
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op2
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/result
add wave -noupdate /testbench/uut/RegWriteEn_inst1_WB
add wave -noupdate /testbench/uut/RegWriteEn_inst2_WB
add wave -noupdate /testbench/uut/RegWriteEn_inst1_EX
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1
add wave -noupdate /testbench/uut/MemtoReg_inst1_Mem
add wave -noupdate /testbench/uut/RegWriteEn_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/pcPlus1_EX
add wave -noupdate -radix unsigned /testbench/uut/pcBranch_EX_inst1
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[22]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[1]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[25]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[24]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[23]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[31]}
add wave -noupdate /testbench/uut/opcode_inst2
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate -radix decimal /testbench/pcFetch
add wave -noupdate -divider instuctions
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Decode
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Decode
add wave -noupdate -divider RF
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[14]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[10]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[9]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[4]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[5]}
add wave -noupdate -divider PC
add wave -noupdate -radix decimal /testbench/uut/pcF_pipe
add wave -noupdate -radix decimal /testbench/uut/PC
add wave -noupdate -radix decimal /testbench/uut/pcD
add wave -noupdate /testbench/uut/switchy
add wave -noupdate -radix unsigned /testbench/uut/pc_EX
add wave -noupdate -radix decimal /testbench/uut/pcPlus1F_pipe
add wave -noupdate /testbench/uut/stall_inner
add wave -noupdate /testbench/uut/outer_depend
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst2_Fetch
add wave -noupdate -radix decimal /testbench/uut/pcPlus1D
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_WB
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_WB
add wave -noupdate /testbench/uut/flush_F_1
add wave -noupdate /testbench/uut/flush_F_2
add wave -noupdate /testbench/uut/flush_D_1
add wave -noupdate /testbench/uut/flush_D_2
add wave -noupdate /testbench/uut/flush_E_2
add wave -noupdate -divider prediction
add wave -noupdate /testbench/uut/predictionF_1_pipe
add wave -noupdate /testbench/uut/predictionF_1
add wave -noupdate /testbench/uut/predictionF_2
add wave -noupdate /testbench/uut/predictionF_2_pipe
add wave -noupdate /testbench/uut/prediction_EX_1
add wave -noupdate /testbench/uut/prediction_EX_2
add wave -noupdate /testbench/uut/equal_inst1
add wave -noupdate /testbench/uut/equal_inst2
add wave -noupdate /testbench/uut/xnorOut_1
add wave -noupdate /testbench/uut/xnorOut_2
add wave -noupdate -divider {FORWARDING UNIT}
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst2
add wave -noupdate /testbench/uut/FU/forwardA_inst1
add wave -noupdate /testbench/uut/FU/forwardB_inst1
add wave -noupdate /testbench/uut/FU/forwardA_inst2
add wave -noupdate /testbench/uut/FU/forwardB_inst2
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/op1
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/op2
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/result
add wave -noupdate -divider {ALU 2}
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op1
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op2
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/result
add wave -noupdate /testbench/uut/RegWriteEn_inst1_EX
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1
add wave -noupdate /testbench/uut/MemtoReg_inst1_Mem
add wave -noupdate /testbench/uut/RegWriteEn_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/pcPlus1_EX
add wave -noupdate -radix unsigned /testbench/uut/pcBranch_EX_inst1
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[22]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[1]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[25]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[23]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[31]}
add wave -noupdate /testbench/uut/opcode_inst2
add wave -noupdate /testbench/uut/predictionF_2_pipe
add wave -noupdate /testbench/uut/predictionF_2_pipe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31092 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 468
configure wave -valuecolwidth 79
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
WaveRestoreZoom {0 ps} {104561 ps}
