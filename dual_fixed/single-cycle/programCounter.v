module programCounter (clk, reset, PCin, PCout);
	
input clk,reset;
input [7:0] PCin;
output reg [7:0] PCout;

always @(posedge clk, negedge reset)
	begin
	
	if (~reset)
		PCout <= 8'b11111111;
		
	else
		PCout<=PCin;
	end

endmodule 
