module Mux3to1 #(parameter size = 32) (in1,in2,in3,s,out);

input[size-1:0] in1,in2,in3;
input[1:0] s;
output reg[size-1:0] out;

always @(*)
	begin
	case(s)
		2'b00: out = in1;
		2'b01: out = in2;
		2'b10: out = in3;
	
		default: out = 0;
		
	endcase
	end 	
endmodule 