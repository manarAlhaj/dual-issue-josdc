module CheckInnerDep(
    input [4:0] Rs_D_inst1,
    input [4:0] Rs_D_inst2,
    input [4:0] Rt_D_inst1,
    input [4:0] Rt_D_inst2,
    input [4:0] Rd_D_inst1,
    input [4:0] Rd_D_inst2,
    input RegWriteEn_inst1,
    input RegWriteEn_inst2,
    input opcode_inst1,
    input opcode_inst2,
    input prediction,
    output reg Stall,
    output reg flush_inst2_B,
    output reg NEWRegWriteEn_inst1
    );

always @(*) begin
    Stall = 1'd0;
    flush_inst2_B= 1'd0;
    NEWRegWriteEn_inst1=RegWriteEn_inst1;
//check data hazards
    //check for RAW
        if( RegWriteEn_inst1 && ((Rd_D_inst1 == Rs_D_inst2 )&& (Rd_D_inst1 != 0) )||((Rd_D_inst1 == Rt_D_inst2 )&& (Rd_D_inst1 != 0)))
            Stall = 1'd1;
   //check for WAR
        if( RegWriteEn_inst2 && ((Rd_D_inst2 == Rs_D_inst1 )&& (Rd_D_inst2 != 0) )||((Rd_D_inst2 == Rt_D_inst1 )&& (Rd_D_inst2 != 0)))
            Stall = 1'd1;
   //check for WAW
        if( (RegWriteEn_inst1 && RegWriteEn_inst2 &&(Rd_D_inst1 == Rd_D_inst2 )&& (Rd_D_inst1 != 0) ))
            NEWRegWriteEn_inst1=1'd0;
//if branch is inst 1 and prediction is taken then flush 2nd ist
        if ((opcode_inst1== 6'b000100 && prediction_1==1) ||(opcode_inst1== 6'b000101 && prediction_1==1 ))
            flush_inst2_B= 1'd1;
// if branch is inst 1 and inst 2 is also a branch then flush 2nd branch 
        if ((opcode_inst1== 6'b000100 && (opcode_inst2== 6'b000100 || opcode_inst2== 6'b000101)) || 
            (opcode_inst1== 6'b000101 && (opcode_inst2== 6'b000100 || opcode_inst2== 6'b000101) ))
            flush_inst2_B= 1'd1;


end
//notes : for top level 
//stall = 1 means we need to stall the 2nd instruction 
// pc should increment by 1 that cycle
// is used as a select line for the MUXes where : 
//the the 1st mux selects whether we want inst 2 (stalled) or the next inst (inst 1 from the next packet)(inst 3)
//the 2nd mux selects whether we want inst 3 (caused by the stall) or the next inst (inst 2 from the next packet)(inst 4)
endmodule
