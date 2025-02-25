module ID1_ID2_inst2Pipe (
	input clk,
	input reset,
    input [31:0] instruction2Decode,
    input [7:0] pcPlus2_D,
    input [7:0] pcBranchD,
    input predictionD,

    input flush1_J,
    input flush_JB,
    input flush1_JR,
    input flush2_JR,
    input flush1_B,
    input flush2_B,
 

    input stall_inner,
    input stall_outer,

    input MemReadEn_inst2_D,
    input MemWriteEn_inst2_D,
    input RegWriteEn_inst2_D,
    input ALUSrc_inst2_D,
    input JUMP_inst2_D,
    input Branch_inst2_D,
    input PCsrc_inst2_D,
    input [1:0] MemtoReg_inst2_D,
    input [1:0] RegDst_inst2_D,
    input [3:0] ALUOp_inst2_D,
    input sign_ext__inst2_D1,

 
    output reg [31:0] instruction2Decode_stage2,

    output reg [7:0] pcPlus2_D2,
    output reg [7:0] pcBranchD_stage2,
	output reg predictionD_stage2,

    output reg MemReadEn_inst2_D2,
    output reg MemWriteEn_inst2_D2,
    output reg RegWriteEn_inst2_D2,
    output reg ALUSrc_inst2_D2,
    output reg JUMP_inst2_D2,
    output reg Branch_inst2_D2,
    output reg PCsrc_inst2_D2,
    output reg [1:0] MemtoReg_inst2_D2,
    output reg [1:0] RegDst_inst2_D2,
    output reg [3:0] ALUOp_inst2_D2,
    output reg sign_ext_inst2_D2

);

always @ (posedge clk, negedge reset) begin
    if (~reset) 
      begin
        instruction2Decode_stage2 <= 32'b0;
        pcPlus2_D2 <= 8'b0;
        pcBranchD_stage2 <= 8'b0;
        predictionD_stage2 = 1'b0;
        //inst2 signals
        MemReadEn_inst2_D2 <= 1'b0;
        MemWriteEn_inst2_D2<= 1'b0;
        RegWriteEn_inst2_D2<= 1'b0;
        ALUSrc_inst2_D2 <= 1'b0;
        JUMP_inst2_D2 <= 1'b0;
        Branch_inst2_D2 <= 1'b0;
        PCsrc_inst2_D2 <= 1'b0;
        MemtoReg_inst2_D2 <= 2'b0;
        RegDst_inst2_D2 <= 2'b0;
        ALUOp_inst2_D2 <= 4'b0;
        sign_ext_inst2_D2 <= 1'b0;

   //jump2 & ~beq_upper -> pc = jump TA in decode , upper instruction will continue executing
    //beq/label 
   //jump2 & beq upper -> continue until branch is resolved in E   
    end
        else if(flush1_B || flush2_B||flush_inst2_B) // prediction != actualprediction

            begin
                instruction2Decode_stage2 <= 32'b0; // Flush lower instruction
                pcBranchD_stage2 <= 8'b0;
                pcPlus2_D2 <= 8'b0;
                predictionD_stage2 <= 1'b0;
                MemReadEn_inst2_D2 <= 1'b0;
                MemWriteEn_inst2_D2 <= 1'b0;
                RegWriteEn_inst2_D2 <= 1'b0;
                ALUSrc_inst2_D2 <= 1'b0;
                JUMP_inst2_D2 <= 1'b0;
                Branch_inst2_D2 <= 1'b0;
                PCsrc_inst2_D2 <= 1'b0;
                MemtoReg_inst2_D2 <= 2'b0;
                RegDst_inst2_D2 <= 2'b0;
                ALUOp_inst2_D2 <= 4'b0;
                sign_ext_inst2_D2 <= 1'b0;

            end   
    else if (flush1_JR || flush1_J || flush_JB || flush2_JR) //flush_B will be the if its a wrong prediction from bpu //assume flush cause is Jump instructions which are resolved in decode stage. (Jump instruction is an upper instruction)
        begin

            instruction2Decode_stage2 <= 32'b0; // Flush lower instruction
            pcBranchD_stage2 <= 8'b0;
            pcPlus2_D2 <= 8'b0;
            predictionD_stage2 <= 1'b0;
            MemReadEn_inst2_D2 <= 1'b0;
            MemWriteEn_inst2_D2 <= 1'b0;
            RegWriteEn_inst2_D2 <= 1'b0;
            ALUSrc_inst2_D2 <= 1'b0;
            JUMP_inst2_D2 <= 1'b0;
            Branch_inst2_D2 <= 1'b0;
            PCsrc_inst2_D2 <= 1'b0;
            MemtoReg_inst2_D2 <= 2'b0;
            RegDst_inst2_D2 <= 2'b0;
            ALUOp_inst2_D2 <= 4'b0;
            sign_ext_inst2_D2 <= 1'b0;

            
        end
                       
    else if(stall_inner||stall_outer) // stall when ld and the use are the upper instruction 
        begin

            instruction2Decode_stage2 <= 32'b0; 
            pcBranchD_stage2 <= 8'b0;
            predictionD_stage2 <= 1'b0;
            MemReadEn_inst2_D2 <= 1'b0;
            MemWriteEn_inst2_D2 <= 1'b0;
            RegWriteEn_inst2_D2 <= 1'b0;
            ALUSrc_inst2_D2 <= 1'b0;
            JUMP_inst2_D2 <= 1'b0;
            Branch_inst2_D2 <= 1'b0;
            PCsrc_inst2_D2 <= 1'b0;
            MemtoReg_inst2_D2 <= 2'b0;
            RegDst_inst2_D2 <= 2'b0;
            ALUOp_inst2_D2 <= 4'b0;
            sign_ext_inst2_D2 <=1'b0;

           
        end

    else  
      begin
        instruction2Decode_stage2 <= instruction2Decode;
        pcPlus2_D2 <= pcPlus2_D;
        pcBranchD_stage2<=pcBranchD;
        predictionD_stage2<=predictionD;   
        MemReadEn_inst2_D2<= MemReadEn_inst2_D;
        MemWriteEn_inst2_D2<= MemWriteEn_inst2_D;
        RegWriteEn_inst2_D2<= RegWriteEn_inst2_D;
        ALUSrc_inst2_D2 <= ALUSrc_inst2_D;
        JUMP_inst2_D2 <= JUMP_inst2_D;
        Branch_inst2_D2 <= Branch_inst2_D;
        PCsrc_inst2_D2 <= PCsrc_inst2_D;
        MemtoReg_inst2_D2 <= MemtoReg_inst2_D;
        RegDst_inst2_D2 <= RegDst_inst2_D;
        ALUOp_inst2_D2 <= ALUOp_inst2_D;
        sign_ext_inst2_D2 <=sign_ext__inst2_D1;
      end
    end
endmodule