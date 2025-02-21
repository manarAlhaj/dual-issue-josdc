module ID_EX_inst2Pipe (
    input clk,
    input reset,
    input [4:0] Rd_D_inst2,
    input [4:0] Rs_D_inst2,
    input [4:0] Rt_D_inst2,
    input [31:0] readData1_D_inst2,
    input [31:0] readData2_D_inst2,
    input [31:0] Imm_D_inst2,
    input [7:0] pcBranchD,
	input predictionD_2,
    input [4:0] shamt_inst2,
	 input [7:0] pcD_inst2,
	 input flush_D_2,
	 input bit26_D_inst2,
    input MemReadEn_inst2_D,
    input MemWriteEn_inst2_D,
    input RegWriteEn_inst2_D,
    input ALUSrc_inst2_D,
   
    input Branch_inst2_D,

    input [1:0] MemtoReg_inst2_D,
    input [1:0] RegDst_inst2_D,
    input [3:0] ALUOp_inst2_D,

    output reg [4:0] Rd_EX_inst2,
    output reg [4:0] Rs_EX_inst2,
    output reg [4:0] Rt_EX_inst2,
    output reg [31:0] readData1_EX_inst2,
    output reg [31:0] readData2_EX_inst2,
    output reg [31:0] Imm_EX_inst2,
    output reg [7:0] pcBranch_EX,
    output reg prediction_EX_2,
    output reg [4:0] shamt_inst2_EX,
	    output reg [7:0] pcE_inst2,
    output reg MemReadEn_inst2_EX,
    output reg MemWriteEn_inst2_EX,
    output reg RegWriteEn_inst2_EX,
    output reg ALUSrc_inst2_EX,
   output reg bit26_E_inst2,
    output reg Branch_inst2_EX,

    output reg [1:0] MemtoReg_inst2_EX,
    output reg [1:0] RegDst_inst2_EX,
    output reg [3:0] ALUOp_inst2_EX
);

always @(posedge clk, negedge reset) 
    begin
        if(~reset)
        begin
       pcE_inst2 <= 8'b0;
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
			pcE_inst2<= 8'b0;
        Branch_inst2_EX <= 1'b0;
        bit26_E_inst2 <=1'b0;
        MemtoReg_inst2_EX <= 2'b0;
        RegDst_inst2_EX <= 2'b0;
        ALUOp_inst2_EX <= 4'b0; 
        end
    // here we added the flush jump signal only when the jump instr is precendented? by a beq type inst
        else if (flush_D_2)
        begin
            Rd_EX_inst2 <= 5'b0;
            Rs_EX_inst2 <= 5'b0;
            Rt_EX_inst2 <= 5'b0;
            readData1_EX_inst2 <= 32'b0;
            readData2_EX_inst2 <= 32'b0;
            Imm_EX_inst2 <= 32'b0;
            pcE_inst2 <= 8'b0;
            pcBranch_EX <= 8'b0;
            prediction_EX_2 <= 1'b0;
            shamt_inst2_EX <=5'b0;
            MemReadEn_inst2_EX <= 1'b0;
            MemWriteEn_inst2_EX <= 1'b0;
            RegWriteEn_inst2_EX <= 1'b0;
            ALUSrc_inst2_EX <= 1'b0;
            
            Branch_inst2_EX <= 1'b0;
                bit26_E_inst2 <=1'b0;
            MemtoReg_inst2_EX <= 2'b0;
            RegDst_inst2_EX <= 2'b0;
            ALUOp_inst2_EX <= 4'b0; 
        end
		  

        
        else 
            begin
                Rd_EX_inst2 <= Rd_D_inst2;
                Rs_EX_inst2 <= Rs_D_inst2;
                Rt_EX_inst2 <= Rt_D_inst2;
                readData1_EX_inst2 <= readData1_D_inst2;
                readData2_EX_inst2 <= readData2_D_inst2;
                Imm_EX_inst2 <= Imm_D_inst2;
                 pcE_inst2<= pcD_inst2;
                pcBranch_EX <= pcBranchD;
                prediction_EX_2 <= predictionD_2;
                shamt_inst2_EX <=shamt_inst2;
                MemReadEn_inst2_EX <= MemReadEn_inst2_D;
                MemWriteEn_inst2_EX <= MemWriteEn_inst2_D;
                RegWriteEn_inst2_EX <= RegWriteEn_inst2_D;
                ALUSrc_inst2_EX <= ALUSrc_inst2_D;
               
                Branch_inst2_EX <= Branch_inst2_D;
                     bit26_E_inst2 <=     bit26_D_inst2;
                MemtoReg_inst2_EX <= MemtoReg_inst2_D;
                RegDst_inst2_EX <= RegDst_inst2_D;
                ALUOp_inst2_EX <= ALUOp_inst2_D;
            end


        
    end


    
endmodule