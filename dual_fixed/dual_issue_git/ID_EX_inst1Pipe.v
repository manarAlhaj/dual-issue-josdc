module ID_EX_inst1Pipe(
    input clk,
    input reset,
    input [4:0] Rd_D_inst1,
    input [4:0] Rs_D_inst1,
    input [4:0] Rt_D_inst1,
    input [31:0] readData1_D_inst1,
    input [31:0] readData2_D_inst1,
    input [31:0] Imm_D_inst1,
    input [7:0] pcBranchD,
    
    input [7:0] pcD, 
		input predictionD,
    input [4:0] shamt_inst1,
	
	 input bit26_D_inst1,
   input [7:0] pcPlus2_D,
    input flush_D_1,
    input MemReadEn_inst1_D,
    input MemWriteEn_inst1_D,
    input RegWriteEn_inst1_D,
    input ALUSrc_inst1_D,
    input Branch_inst1_D,
 
    input [1:0] MemtoReg_inst1_D,
    input [1:0] RegDst_inst1_D,
    input [3:0] ALUOp_inst1_D,


    output reg [4:0] Rd_EX_inst1,
    output reg [4:0] Rs_EX_inst1,
    output reg [4:0] Rt_EX_inst1,
    output reg [31:0] readData1_EX_inst1,
    output reg [31:0] readData2_EX_inst1,
    output reg [31:0] Imm_EX_inst1,
    output reg [7:0] pc_EX,

    output reg [7:0] pcBranch_EX,
    output reg prediction_EX,
    output reg [4:0] shamt_inst1_EX,
    output reg MemReadEn_inst1_EX,
    output reg MemWriteEn_inst1_EX,
    output reg RegWriteEn_inst1_EX,
    output reg ALUSrc_inst1_EX,
   output reg [7:0] pcPlus2_EX,
    output reg Branch_inst1_EX,
	 output reg bit26_E_inst1,
    output reg [1:0] MemtoReg_inst1_EX,
    output reg [1:0] RegDst_inst1_EX,
    output reg [3:0] ALUOp_inst1_EX
);

always @(posedge clk, negedge reset) 
    begin
        if(~reset)
        begin
        Rd_EX_inst1 <= 5'b0;
        Rs_EX_inst1 <= 5'b0;
        Rt_EX_inst1 <= 5'b0;
        readData1_EX_inst1 <= 32'b0;
        readData2_EX_inst1 <= 32'b0;
        Imm_EX_inst1 <= 32'b0;
		  pcPlus2_EX <=8'b0;
        pc_EX <= 8'b0;
        
        pcBranch_EX <= 8'b0;
        prediction_EX <= 1'b0;
        shamt_inst1_EX <=5'b0;
        MemReadEn_inst1_EX <= 1'b0;
        MemWriteEn_inst1_EX <= 1'b0;
        RegWriteEn_inst1_EX <= 1'b0;
        ALUSrc_inst1_EX <= 1'b0;
			 bit26_E_inst1 <=1'b0;
        Branch_inst1_EX <= 1'b0;
   
        MemtoReg_inst1_EX <= 2'b0;
        RegDst_inst1_EX <= 2'b0;
        ALUOp_inst1_EX <= 4'b0; 
        end

        else if (flush_D_1)
        begin
            Rd_EX_inst1 <= 5'b0;
            Rs_EX_inst1 <= 5'b0;
            Rt_EX_inst1 <= 5'b0;
            readData1_EX_inst1 <= 32'b0;
            readData2_EX_inst1 <= 32'b0;
            Imm_EX_inst1 <= 32'b0;
				pcPlus2_EX <=8'b0;
            pc_EX <= 8'b0;
            
            pcBranch_EX <= 8'b0;
            prediction_EX <= 1'b0;
            shamt_inst1_EX <=5'b0;
            MemReadEn_inst1_EX <= 1'b0;
            MemWriteEn_inst1_EX <= 1'b0;
            RegWriteEn_inst1_EX <= 1'b0;
            ALUSrc_inst1_EX <= 1'b0;
				bit26_E_inst1 <=1'b0;
            Branch_inst1_EX <= 1'b0;
          
            MemtoReg_inst1_EX <= 2'b0;
            RegDst_inst1_EX <= 2'b0;
            ALUOp_inst1_EX <= 4'b0; 
        end
		  
        
        else 
            begin
                shamt_inst1_EX <=shamt_inst1;
					  pcPlus2_EX <=pcPlus2_D;
                Rd_EX_inst1 <= Rd_D_inst1;
                Rs_EX_inst1 <= Rs_D_inst1;
                Rt_EX_inst1 <= Rt_D_inst1;
                readData1_EX_inst1 <= readData1_D_inst1;
                readData2_EX_inst1 <= readData2_D_inst1;
                Imm_EX_inst1 <= Imm_D_inst1;
                pc_EX<= pcD;
               
                pcBranch_EX <= pcBranchD;
                prediction_EX <= predictionD;
                MemReadEn_inst1_EX <= MemReadEn_inst1_D;
                MemWriteEn_inst1_EX <= MemWriteEn_inst1_D;
                RegWriteEn_inst1_EX <= RegWriteEn_inst1_D;
                ALUSrc_inst1_EX <= ALUSrc_inst1_D;
						bit26_E_inst1 <=bit26_D_inst1;
                Branch_inst1_EX <= Branch_inst1_D;
                MemtoReg_inst1_EX <= MemtoReg_inst1_D;
                RegDst_inst1_EX <= RegDst_inst1_D;
                ALUOp_inst1_EX <= ALUOp_inst1_D;
            end


        
    end




    endmodule