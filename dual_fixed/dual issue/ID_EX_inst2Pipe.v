module ID_EX_inst2Pipe (
    input clk,
    input reset,
    input [4:0] Rd_D2_inst2,
    input [4:0] Rs_D2_inst2,
    input [4:0] Rt_D2_inst2,
    input [31:0] readData1_D2_inst2,
    input [31:0] readData2_D2_inst2,
    input [31:0] Imm_D2_inst2,
    input [7:0] pcBranchD_stage2,
    input [7:0] pcPlus2_D2,
	input predictionD_2,
    input [4:0] shamt_inst2,
    input flush1_B,
    input flush2_B,
    input flush1_JR,
    input flush1_J,
    input flush_inst2_B,

    input MemReadEn_inst2_D2,
    input MemWriteEn_inst2_D2,
    input RegWriteEn_inst2_D2,
    input ALUSrc_inst2_D2,
    input JUMP_inst2_D2,
    input Branch_inst2_D2,
    input PCsrc_inst2_D2,
    input [1:0] MemtoReg_inst2_D2,
    input [1:0] RegDst_inst2_D2,
    input [3:0] ALUOp_inst2_D2,

    output reg [4:0] Rd_EX_inst2,
    output reg [4:0] Rs_EX_inst2,
    output reg [4:0] Rt_EX_inst2,
    output reg [31:0] readData1_EX_inst2,
    output reg [31:0] readData2_EX_inst2,
    output reg [31:0] Imm_EX_inst2,
    output reg [7:0] pcPlus2_EX,
    output reg [7:0] pcBranch_EX,
    output reg prediction_EX_2,
    output reg [4:0] shamt_inst2_EX,
    output reg MemReadEn_inst2_EX,
    output reg MemWriteEn_inst2_EX,
    output reg RegWriteEn_inst2_EX,
    output reg ALUSrc_inst2_EX,
    output reg JUMP_inst2_EX,
    output reg Branch_inst2_EX,
    output reg PCsrc_inst2_EX,
    output reg [1:0] MemtoReg_inst2_EX,
    output reg [1:0] RegDst_inst2_EX,
    output reg [3:0] ALUOp_inst2_EX
);

always @(posedge clk, negedge reset) 
    begin
        if(~reset)
        begin
        pcPlus2_EX <= 8'b0;
        Rd_EX_inst2 <= 5'b0;
        Rs_EX_inst2 <= 5'b0;
        Rt_EX_inst2 <= 5'b0;
        readData1_EX_inst2 <= 32'b0;
        readData2_EX_inst2 <= 32'b0;
        Imm_EX_inst2 <= 32'b0;
        pcBranch_EX <= 8'b0;
        prediction_EX_2 <= 1'b0;
        shamt_inst2_EX <=5'b0;
        MemReadEn_inst2_EX <= 1'b0;
        MemWriteEn_inst2_EX <= 1'b0;
        RegWriteEn_inst2_EX <= 1'b0;
        ALUSrc_inst2_EX <= 1'b0;
        JUMP_inst2_EX <= 1'b0;
        Branch_inst2_EX <= 1'b0;
        PCsrc_inst2_EX <= 1'b0;
        MemtoReg_inst2_EX <= 2'b0;
        RegDst_inst2_EX <= 2'b0;
        ALUOp_inst2_EX <= 4'b0; 
        end
    // here we added the flush jump signal only when the jump instr is precendented? by a beq type inst
        else if (flush1_B || flush2_B||flush1_JR ||flush1_J|| flush_inst2_B)
        begin
            Rd_EX_inst2 <= 5'b0;
            Rs_EX_inst2 <= 5'b0;
            Rt_EX_inst2 <= 5'b0;
            readData1_EX_inst2 <= 32'b0;
            readData2_EX_inst2 <= 32'b0;
            Imm_EX_inst2 <= 32'b0;
            pcPlus2_EX <=8'b0;
            pcBranch_EX <= 8'b0;
            prediction_EX_2 <= 1'b0;
            shamt_inst2_EX <=5'b0;
            MemReadEn_inst2_EX <= 1'b0;
            MemWriteEn_inst2_EX <= 1'b0;
            RegWriteEn_inst2_EX <= 1'b0;
            ALUSrc_inst2_EX <= 1'b0;
            JUMP_inst2_EX <= 1'b0;
            Branch_inst2_EX <= 1'b0;
            PCsrc_inst2_EX <= 1'b0;
            MemtoReg_inst2_EX <= 2'b0;
            RegDst_inst2_EX <= 2'b0;
            ALUOp_inst2_EX <= 4'b0; 
        end
        
        else 
            begin
                Rd_EX_inst2 <= Rd_D2_inst2;
                Rs_EX_inst2 <= Rs_D2_inst2;
                Rt_EX_inst2 <= Rt_D2_inst2;
                readData1_EX_inst2 <= readData1_D2_inst2;
                readData2_EX_inst2 <= readData2_D2_inst2;
                Imm_EX_inst2 <= Imm_D2_inst2;
                pcPlus2_EX <= pcPlus2_D2;
                pcBranch_EX <= pcBranchD_stage2;
                prediction_EX_2 <= predictionD_2;
                shamt_inst2_EX <=shamt_inst2;
                MemReadEn_inst2_EX <= MemReadEn_inst2_D2;
                MemWriteEn_inst2_EX <= MemWriteEn_inst2_D2;
                RegWriteEn_inst2_EX <= RegWriteEn_inst2_D2;
                ALUSrc_inst2_EX <= ALUSrc_inst2_D2;
                JUMP_inst2_EX <= JUMP_inst2_D2;
                Branch_inst2_EX <= Branch_inst2_D2;
                PCsrc_inst2_EX <= PCsrc_inst2_D2;
                MemtoReg_inst2_EX <= MemtoReg_inst2_D2;
                RegDst_inst2_EX <= RegDst_inst2_D2;
                ALUOp_inst2_EX <= ALUOp_inst2_D2;
            end


        
    end


    
endmodule