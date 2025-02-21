// sign Extender
// input is 16 bit, output is 32 bit

module SignExtender(immediate, sign_ext, ext_immediate);
input [15:0] immediate;
input sign_ext;
output reg [31:0] ext_immediate;

always @(*)
	begin 
	
	if(sign_ext)
		ext_immediate = {{16{immediate[15]}}, immediate};
	else
		ext_immediate = {16'b0,immediate};
		
	end
endmodule





