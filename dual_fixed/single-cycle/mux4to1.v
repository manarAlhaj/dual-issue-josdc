module mux4to1 #(parameter size = 32) (in1,in2,in3,in4,S,out);

input[size-1:0] in1,in2,in3,in4;
input[1:0] S;
output reg[size-1:0] out;

always @(*)
	begin
	case(S)
		2'b00: out = in1;
		2'b01: out = in2;
		2'b10: out = in3;
		2'b11: out = in4;
	
		default: out = 0;
		
	endcase
	end 	
endmodule 