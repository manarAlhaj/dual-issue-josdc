module ProgramCounter (clk, reset, PCin, PCout,stall, flush);
	
input clk,reset,flush,stall;
input [5:0] PCin;
output reg [5:0] PCout;

always @(posedge clk, negedge reset)
	begin
	
	if (~reset)
		PCout <= 6'b111111;
	else if(flush)
		PCout <= 6'b111111;
	else if (~stall)
		PCout<=PCin;
	else ;
	
	end

endmodule 
