// sign Extender
// input is 16 bit, output is 32 bit

module SignExtender(immediate, signExtend, extendedImmediate);
input [15:0] immediate;
input signExtend;
output reg [31:0] extendedImmediate;

always @(*)
	begin 
	
	if(signExtend)
		extendedImmediate = {{16{immediate[15]}}, immediate};
	else
		extendedImmediate = {16'b0,immediate};
		
	end
endmodule





