module Mux2to1 #(parameter size = 32) (in1, in2, s, out);

	// inputs	
	input s;
	input [size-1:0] in1, in2; //Error it was [size:0]
	
	// outputs
	output [size-1:0] out;

	// Unit logic
	assign out = (~s) ? in1 : in2;
	
endmodule
