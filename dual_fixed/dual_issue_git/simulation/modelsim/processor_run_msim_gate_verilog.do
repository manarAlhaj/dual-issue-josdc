transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {processor.vo}

vlog -vlog01compat -work work +incdir+C:/Users/Windows/Desktop/cache-me-if-you-can-main/dual_proc_quartus {C:/Users/Windows/Desktop/cache-me-if-you-can-main/dual_proc_quartus/testbench.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
