module ID1_ID2_inst1Pipe(
    input clk,
    input reset,
    input [31:0] instruction1Decode,
    input [7:0] pcD, 
    input [7:0] pcPlus1D,
	input [7:0] pcBranchD,
	input predictionD,

    input flush_JB,
    input flush1_JR,
    input flush2_JR,
    input flush1_B,
    input flush2_B,

    input stall_outer,
    input MemReadEn_inst1_D,
    input MemWriteEn_inst1_D,
    input RegWriteEn_inst1_D,
    input ALUSrc_inst1_D,
    input JUMP_inst1_D,
    input Branch_inst1_D,
    input PCsrc_inst1_D,
    input [1:0] MemtoReg_inst1_D,
    input [1:0] RegDst_inst1_D,
    input [3:0] ALUOp_inst1_D,
    input sign_ext_inst1_D1,

    output reg [31:0] instruction1Decode_stage2,

    output reg [7:0] pcD_stage2, 
    output reg [5:0] pcPlus1D_stage2,
	output reg [7:0] pcBranchD_stage2,
	output reg predictionD_stage2,

    output reg MemReadEn_inst1_D2,
    output reg MemWriteEn_inst1_D2,
    output reg RegWriteEn_inst1_D2,
    output reg ALUSrc_inst1_D2,
    output reg JUMP_inst1_D2,
    output reg Branch_inst1_D2,
    output reg PCsrc_inst1_D2,
    output reg [1:0] MemtoReg_inst1_D2,
    output reg [1:0] RegDst_inst1_D2,
    output reg [3:0] ALUOp_inst1_D2,
    output reg sign_ext_inst1_D2

);

 always @ (posedge clk, negedge reset) begin
        if (~reset) 
		  begin
            instruction1Decode_stage2 <= 32'b0;
            pcD_stage2 <= 8'b0;
            pcPlus1D_stage2 <= 6'b0;
            pcBranchD_stage2 <= 8'b0;
            predictionD_stage2 = 1'b0;
            //inst1 signals
            MemReadEn_inst1_D2<= 1'b0;
            MemWriteEn_inst1_D2<= 1'b0;
            RegWriteEn_inst1_D2<= 1'b0;
            ALUSrc_inst1_D2 <= 1'b0;
            JUMP_inst1_D2 <= 1'b0;
            Branch_inst1_D2 <= 1'b0;
            PCsrc_inst1_D2 <= 1'b0;
            MemtoReg_inst1_D2 <= 2'b0;
            RegDst_inst1_D2 <= 2'b0;
            ALUOp_inst1_D2 <= 4'b0;
            sign_ext_inst1_D2 <= 1'b0;
            
       //jump2 & ~beq_upper -> pc = jump TA in decode , upper instruction will continue executing
        //beq/label 
       //jump2 & beq upper -> continue until branch is resolved in E   
        end

        else if (flush1_JR || flush2_JR) //flush_B will be the if its a wrong prediction from bpu //assume flush cause is Jump instructions which are resolved in decode stage. (Jump instruction is an upper instruction)
            begin

                instruction1Decode_stage2 <= 32'b0; // Flush upper instruction
                pcD_stage2 <= 8'b0;
                pcBranchD_stage2 <= 8'b0;
                pcPlus1D_stage2 <= 8'b0;
                predictionD_stage2 <= 1'b0;
                MemReadEn_inst1_D2 <= 1'b0;
                MemWriteEn_inst1_D2 <= 1'b0;
                RegWriteEn_inst1_D2 <= 1'b0;
                ALUSrc_inst1_D2 <= 1'b0;
                JUMP_inst1_D2 <= 1'b0;
                Branch_inst1_D2 <= 1'b0;
                PCsrc_inst1_D2 <= 1'b0;
                MemtoReg_inst1_D2 <= 2'b0;
                RegDst_inst1_D2 <= 2'b0;
                ALUOp_inst1_D2 <= 4'b0;
                sign_ext_inst1_D2 <= 1'b0;

                
                
            end
            // 
            else if(flush_JB)

                begin
                instruction1Decode_stage2 <= instruction1Decode;
                pcD_stage2 <= pcD;
                pcBranchD_stage2<=pcBranchD;
                pcPlus1D_stage2 <= pcPlus1D;
                predictionD_stage2<=predictionD;   
                MemReadEn_inst1_D2<= MemReadEn_inst1_D;
                MemWriteEn_inst1_D2<= MemWriteEn_inst1_D;
                RegWriteEn_inst1_D2<= RegWriteEn_inst1_D;
                ALUSrc_inst1_D2 <= ALUSrc_inst1_D;
                JUMP_inst1_D2 <= JUMP_inst1_D;
                Branch_inst1_D2 <= Branch_inst1_D;
                PCsrc_inst1_D2 <= PCsrc_inst1_D;
                MemtoReg_inst1_D2 <= MemtoReg_inst1_D;
                RegDst_inst1_D2 <= RegDst_inst1_D;
                ALUOp_inst1_D2 <= ALUOp_inst1_D;
                sign_ext_inst1_D2 <=sign_ext_inst1_D1 ; 

                end

            else if(flush1_B || flush2_B) // prediction != actualprediction
            // no need for inst 2 consideration . in this stage , 
            //if we flush inst2 because of branch we will also need to do so with 1 because its resolved in a later stage 
                begin
                instruction1Decode_stage2 <= 32'b0; // Flush upper instruction
                pcD_stage2 <= 8'b0;
                pcPlus1D_stage2 <= 8'b0;
                pcBranchD_stage2 <= 8'b0;
                predictionD_stage2 <= 1'b0;
                MemReadEn_inst1_D2 <= 1'b0;
                MemWriteEn_inst1_D2 <= 1'b0;
                RegWriteEn_inst1_D2 <= 1'b0;
                ALUSrc_inst1_D2 <= 1'b0;
                JUMP_inst1_D2 <= 1'b0;
                Branch_inst1_D2 <= 1'b0;
                PCsrc_inst1_D2 <= 1'b0;
                MemtoReg_inst1_D2 <= 2'b0;
                RegDst_inst1_D2 <= 2'b0;
                ALUOp_inst1_D2 <= 4'b0;
                sign_ext_inst1_D2 <=1'b0;
                end    
        			
		else if(stall_outer) // stall when ld and the use are the upper instruction 
        // stalls @ outer dep only
			begin

                instruction1Decode_stage2 <= 32'b0; 
                pcD_stage2 <= 8'b0;
                pcBranchD_stage2 <= 8'b0;
                pcPlus1D_stage2 <= 8'b0; 
                predictionD_stage2 <= 1'b0;
                MemReadEn_inst1_D2 <= 1'b0;
                MemWriteEn_inst1_D2 <= 1'b0;
                RegWriteEn_inst1_D2 <= 1'b0;
                ALUSrc_inst1_D2 <= 1'b0;
                JUMP_inst1_D2 <= 1'b0;
                Branch_inst1_D2 <= 1'b0;
                PCsrc_inst1_D2 <= 1'b0;
                MemtoReg_inst1_D2 <= 2'b0;
                RegDst_inst1_D2 <= 2'b0;
                ALUOp_inst1_D2 <= 4'b0;
                sign_ext_inst1_D2 <=1'b0;

               
			end
   
        else  
		  begin
            instruction1Decode_stage2 <= instruction1Decode;
            pcD_stage2 <= pcD;
            pcPlus1D_stage2 <= pcPlus1D;
            pcBranchD_stage2<=pcBranchD;
            predictionD_stage2<=predictionD;   
            MemReadEn_inst1_D2<= MemReadEn_inst1_D;
            MemWriteEn_inst1_D2<= MemWriteEn_inst1_D;
            RegWriteEn_inst1_D2<= RegWriteEn_inst1_D;
            ALUSrc_inst1_D2 <= ALUSrc_inst1_D;
            JUMP_inst1_D2 <= JUMP_inst1_D;
            Branch_inst1_D2 <= Branch_inst1_D;
            PCsrc_inst1_D2 <= PCsrc_inst1_D;
            MemtoReg_inst1_D2 <= MemtoReg_inst1_D;
            RegDst_inst1_D2 <= RegDst_inst1_D;
            ALUOp_inst1_D2 <= ALUOp_inst1_D;
            sign_ext_inst1_D2 <=sign_ext_inst1_D1;
          end
			 end
    endmodule 