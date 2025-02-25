transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/testbench.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/SignExtender.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/registerFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/programCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/OR_GATE_3.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/mux3to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/mux2x1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/controlUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/ANDGate.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/adder.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/instructionMemory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/dataMemory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/XNOR_GATE.v}

vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/SingleCycle {C:/Users/Windows/Desktop/SingleCycle/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 2 sec
