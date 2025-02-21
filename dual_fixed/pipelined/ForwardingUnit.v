module ForwardingUnit(
    input[4:0] Rd_mem,
    input[4:0] Rd_WB,
    input[4:0] Rs_EX,
    input[4:0] Rt_EX,
    input RegWrite_mem, //reg write control signal, 
    input RegWrite_WB,
	
    output reg [1:0] forwardA,
	output reg [1:0] forwardB

);

always @(*) begin
	// frwrd execute
    if(RegWrite_mem && (Rd_mem == Rs_EX ) && (Rd_mem != 0))
        forwardA[0] = 1'd1; 
		  
    else	 
		  forwardA[0] = 1'd0;
			
    if(RegWrite_mem && (Rd_mem == Rt_EX ) && (Rd_mem != 0))
        forwardB[0] = 1'd1;
	 else
			forwardB[0] = 1'd0;
			
//frwrd writeback
    if(RegWrite_WB && (Rd_WB == Rs_EX) && 
        ((Rd_mem != Rs_EX ) || (RegWrite_mem == 0)) 
        && (Rd_WB != 0 ))
        forwardA[1] = 1'd1;
     else
			forwardA[1] = 1'd0;
			
    if(RegWrite_WB && (Rd_WB == Rt_EX) && 
        ((Rd_mem != Rt_EX ) || (RegWrite_mem == 0)) 
        && (Rd_WB != 0 ))
        forwardB[1] = 1'd1;    
            
	 else 
		  forwardB[1] = 1'd0;   
    
end
// forwardA[0]: forward to RD1 in Decode stage from E
endmodule 
