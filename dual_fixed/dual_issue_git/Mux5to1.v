module Mux5to1 #(parameter size = 32) (in1,in2,in3,in4,in5,s,out);

input[size-1:0] in1,in2,in3, in4,in5;
input[2:0] s;
output reg[size-1:0] out;

always @(*)
	begin
	case(s)
		3'b000:  out = in1;
		3'b001:  out = in2;
		3'b010:  out = in3;
        3'b011:  out = in4;
        3'b100:  out = in5;
		default: out = 32'b0;
		
	endcase
	end 	
endmodule 