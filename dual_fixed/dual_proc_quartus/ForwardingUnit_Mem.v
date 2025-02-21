module ForwardingUnit_Mem (
   
    input RegWriteEn_mem_inst1,

    input RegWriteEn_WB_inst1,
    input RegWriteEn_WB_inst2,

    input Branch_inst1_Mem,
    input Branch_inst2_Mem,

    input [4:0] Dest_mem_inst1,//dest reg mux 
    input [4:0] Dest_WB_inst1, 
    input [4:0] Dest_WB_inst2, 

    input [4:0] Rt_mem_inst1, // if branch in lane 1, we need to compare those with dest reg in Write back stage
    input [4:0] Rs_mem_inst1, // if branch in lane 1, we need to compare those with dest reg in Write back stage

    input [4:0] Rt_mem_inst2, // if branch in lane 2, we need to compare those with dest reg in the upper instruction 
    input [4:0] Rs_mem_inst2, // if branch in lane 2, we need to compare those with dest reg in the upper instruction 

    output reg [1:0] ForwardA_branch_1,
    output reg [1:0] ForwardB_branch_1,

    output reg [1:0] ForwardA_branch_2,
    output reg [1:0] ForwardB_branch_2
) ;

reg Forward_mem1_b2, Forward_mem2_b2, Forward_WB2_s1_b2, Forward_WB2_s2_b2, Forward_WB1_s1_b2, Forward_WB1_s2_b2, Forward_WB2_s1_b1, Forward_WB2_s2_b1, Forward_WB1_s1_b1,Forward_WB1_s2_b1 ;

always @(*) 
    begin
        ForwardA_branch_1 = 2'd0;
        ForwardB_branch_1 = 2'd0;

        ForwardA_branch_2 = 2'd0;
        ForwardB_branch_2 = 2'd0;

        Forward_mem1_b2 = (RegWriteEn_mem_inst1 && Branch_inst2_Mem && (Dest_mem_inst1 == Rs_mem_inst2) && (Dest_mem_inst1 != 5'b0));
        Forward_mem2_b2 = (RegWriteEn_mem_inst1 && Branch_inst2_Mem && (Dest_mem_inst1 == Rt_mem_inst2) && (Dest_mem_inst1 != 5'b0)); 

        Forward_WB2_s1_b2 = ((RegWriteEn_WB_inst2 && Branch_inst2_Mem && (Dest_WB_inst2 == Rs_mem_inst2) && (Dest_WB_inst2 != 5'b0))&& ~(Forward_mem1_b2));
        Forward_WB2_s2_b2 = ((RegWriteEn_WB_inst2 && Branch_inst2_Mem && (Dest_WB_inst2 == Rt_mem_inst2) && (Dest_WB_inst2 != 5'b0)) && ~(Forward_mem2_b2));

        Forward_WB1_s1_b2 = ((RegWriteEn_WB_inst1 && Branch_inst2_Mem && (Dest_WB_inst1 == Rs_mem_inst2) && (Dest_WB_inst1 != 5'b0)) && ~(Forward_mem1_b2) && ~(Forward_WB2_s1_b2));
        Forward_WB1_s2_b2 = ((RegWriteEn_WB_inst1 && Branch_inst2_Mem && (Dest_WB_inst1 == Rt_mem_inst2) && (Dest_WB_inst1 != 5'b0)) && ~(Forward_mem2_b2) && ~(Forward_WB2_s2_b2));

        Forward_WB2_s1_b1 = ((RegWriteEn_WB_inst2 && Branch_inst1_Mem && (Dest_WB_inst2 == Rs_mem_inst1) && (Dest_WB_inst2 != 5'b0)));
        Forward_WB2_s2_b1 = ((RegWriteEn_WB_inst2 && Branch_inst1_Mem && (Dest_WB_inst2 == Rt_mem_inst1) && (Dest_WB_inst2 != 5'b0)));

        Forward_WB1_s1_b1 = ((RegWriteEn_WB_inst1 && Branch_inst1_Mem && (Dest_WB_inst1 == Rs_mem_inst1) && (Dest_WB_inst1 != 5'b0)) && ~ (Forward_WB2_s1_b1));
        Forward_WB1_s2_b1 = ((RegWriteEn_WB_inst1 && Branch_inst1_Mem && (Dest_WB_inst1 == Rt_mem_inst1) && (Dest_WB_inst1 != 5'b0)) && ~ (Forward_WB2_s2_b1));
        
        //branch 2 conditions in mem
        if (Forward_mem1_b2)
            begin
                ForwardA_branch_2 = 2'b01;
            end    

        if (Forward_mem2_b2)
            begin
                ForwardB_branch_2 = 2'b01;
            end  

        if (Forward_WB2_s2_b2)
            begin
                ForwardA_branch_2 = 2'b11;
            end 
        
        if (Forward_WB2_s1_b2)
            begin
                ForwardB_branch_2 = 2'b11;
            end     

        if (Forward_WB1_s1_b2)
            begin
                ForwardA_branch_2 = 2'b10;
            end 


        if (Forward_WB1_s2_b2)
            begin
                ForwardB_branch_2 = 2'b10;
            end 

        //branch 1 in mem conditions

        if (Forward_WB2_s1_b1)    
            begin
                ForwardA_branch_1 = 2'b11;
            end
            
        if (Forward_WB2_s2_b1)    
            begin
                ForwardB_branch_1 = 2'b11;
            end
         
        if (Forward_WB1_s1_b1)  
            begin
                ForwardA_branch_1 = 2'b10;
            end  


        if (Forward_WB1_s2_b1)  
            begin
                ForwardB_branch_1 = 2'b10;
            end  

    end
    
endmodule