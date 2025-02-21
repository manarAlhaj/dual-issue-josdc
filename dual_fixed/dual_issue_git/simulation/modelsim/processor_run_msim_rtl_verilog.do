transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/InstructionMemory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/DataMemory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/XnorGate.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/SignExtend.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/RegFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/Mux5to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/Mux3to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/mux2to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/MEM_WB_inst2Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/MEM_WB_inst1Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/IF_ID1_Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/ID_EX_inst2Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/ID_EX_inst1Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/ForwardingUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/EX_MEM_inst2Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/EX_MEM_inst1Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/dual_issue_processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/ControlUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/BranchCmpUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/ANDGate.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/mini_Control_Unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/BPU.v}

vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/dual-old/dual_issue_git {C:/Users/Windows/Desktop/dual-old/dual_issue_git/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
