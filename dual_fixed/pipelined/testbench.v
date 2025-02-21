`timescale 1ns/1ps
module testbench;

	reg clock, reset;
	
	wire [5:0] pcFetch;
	
	initial begin
		clock = 0;
		reset = 0;
		#4 reset = 1;
		#2000 $stop;
	end
	
	always #5 clock = ~clock;
	
	PipelinedProcessor uut(.clock(clock), .reset(reset), .pcFetch(pcFetch));
	
	
endmodule
