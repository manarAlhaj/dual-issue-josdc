
module HazardDetectionUnit
(	 input[4:0] EXMEM_Rd,
    	input[4:0] IDEX_Rs,
	input[4:0] IDEX_Rt,
	input MemRead,
 	input prediction, //bpu 
 	input actual_prediction, //comparator and gate (PcsrsD )
	 //input branch,
	 input PCsrc,
	 output reg flush,
	 output reg stall
	);
	
	always @(*)
		begin
		
		if(MemRead && ((EXMEM_Rd == IDEX_Rs) || (EXMEM_Rd == IDEX_Rt)) && (EXMEM_Rd != 0))
			stall = 1;	
			
		else stall = 0;
		
		flush = ((prediction!=actual_prediction) | PCsrc) & ~stall;	
		end 



endmodule 
