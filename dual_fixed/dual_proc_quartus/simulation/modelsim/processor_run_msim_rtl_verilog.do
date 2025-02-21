transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/InstructionMemory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/DataMemory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/XnorGate.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/SignExtend.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/RegFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/Mux5to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/Mux3to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/mux2to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/MEM_WB_inst2Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/MEM_WB_inst1Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/IF_ID1_Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/ID_EX_inst2Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/ID_EX_inst1Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/gshare_branch_predictor.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/ForwardingUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/EX_MEM_inst2Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/EX_MEM_inst1Pipe.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/dual_issue_processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/ControlUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/BranchCmpUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/ANDGate.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/mini_Control_Unit.v}

vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus {C:/Users/Windows/Desktop/phaseIII_git/cache-me-if-you-can/dual_proc_quartus/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
