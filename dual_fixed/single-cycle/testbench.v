`timescale 1ns/1ps
module testbench;

	reg clk, rst;
	
	wire [7:0] PC;
	
	initial begin
		clk = 0;
		rst = 0;
		#4 rst = 1;
		#4000 $stop;
	end
	
	always #5 clk = ~clk;
	
	processor uut(.clk(clk), .reset(rst), .PC(PC));
	
	
endmodule
