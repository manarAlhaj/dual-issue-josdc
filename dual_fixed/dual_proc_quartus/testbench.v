`timescale 1ns/1ps
module testbench;

	reg clk, reset;
	
	wire [7:0] pcFetch;

	
	initial begin
		clk = 0;
		reset = 0;
		#4 reset = 1;
		#5715 $stop;
	end
	
	always #5 clk = ~clk;
	
	dual_issue_processor uut(.clk(clk), .reset(reset), .PC(pcFetch));
	
	
endmodule
