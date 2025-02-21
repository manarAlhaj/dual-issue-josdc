module EX_MEM_inst1Pipe (
    input clk,
    input reset,
    input [31:0] AluOutExecute_inst1,
    input [31:0] ReadData2Execute_inst1,
    input [4:0] dest_reg_inst1_EX,
    input [7:0] pcPlus1_EX,
    input flush_E_1,
    input MemReadEn_inst1_EX,
    input MemWriteEn_inst1_EX,
    input RegWriteEn_inst1_EX,
    input [1:0] MemtoReg_inst1_EX,

    input Branch_inst1_EX,
    input bit26_E_inst1,
    input [7:0] pcBranch_EX_inst1,
    input [7:0] pc_EX,
    input prediction_EX_1,
    input [4:0] Rs_EX_inst1,
    input [4:0] Rt_EX_inst1,

    output reg [7:0] Branch_inst1_Mem,
    output reg bit26_Mem_inst1,
    output reg [7:0] pcBranch_Mem_inst1,
    output reg [7:0] pc_Mem,
    output reg prediction_Mem_1,
    output reg [4:0]Rs_Mem_inst1,
    output reg [4:0]Rt_Mem_inst1,

    output reg [31:0] AluOutMem_inst1,
    output reg [31:0] ReadData2Mem_inst1,
    output reg [4:0] dest_reg_inst1_Mem,

 

    output reg MemReadEn_inst1_Mem,
    output reg MemWriteEn_inst1_Mem,
    output reg RegWriteEn_inst1_Mem,
	 output reg [7:0] pcPlus1_Mem,
    output reg [1:0] MemtoReg_inst1_Mem
 
);

always @(posedge clk, negedge reset) 
    begin
        if(~reset)
        begin
		
            AluOutMem_inst1<=32'b0;
            ReadData2Mem_inst1 <= 32'b0;
            dest_reg_inst1_Mem <= 5'b0;
            MemReadEn_inst1_Mem <= 1'b0;
            MemWriteEn_inst1_Mem <=1'b0;
            RegWriteEn_inst1_Mem <= 1'b0;
            MemtoReg_inst1_Mem <= 2'b0;
			pcPlus1_Mem <= 8'b0;

            Branch_inst1_Mem <= 8'b0;
            bit26_Mem_inst1 <= 1'b0;
            pcBranch_Mem_inst1 <= 8'b0;
            pc_Mem <= 8'b0;
            prediction_Mem_1 <= 1'b0;
            Rs_Mem_inst1 <= 5'b0;
            Rt_Mem_inst1 <= 5'b0;
       

        end
        else if (flush_E_1)
         begin
            AluOutMem_inst1 <= 32'b0;
            ReadData2Mem_inst1 <= 32'b0;
            dest_reg_inst1_Mem <= 5'b0;
            pcPlus1_Mem <= 8'b0;
            MemReadEn_inst1_Mem <= 1'b0;
            MemWriteEn_inst1_Mem <= 1'b0;
            RegWriteEn_inst1_Mem <= 1'b0;
            MemtoReg_inst1_Mem <= 2'b0;
            
            Branch_inst1_Mem <= 8'b0;
            bit26_Mem_inst1 <= 1'b0;
            pcBranch_Mem_inst1 <= 8'b0;
            pc_Mem <= 8'b0;
            prediction_Mem_1 <= 1'b0;
            Rs_Mem_inst1 <= 5'b0;
            Rt_Mem_inst1 <= 5'b0;
		end

        else
            begin
                
            AluOutMem_inst1<=AluOutExecute_inst1;
            ReadData2Mem_inst1 <= ReadData2Execute_inst1;
            dest_reg_inst1_Mem <= dest_reg_inst1_EX;
            MemReadEn_inst1_Mem <= MemReadEn_inst1_EX;
            MemWriteEn_inst1_Mem <=MemWriteEn_inst1_EX;
            RegWriteEn_inst1_Mem <= RegWriteEn_inst1_EX;
            MemtoReg_inst1_Mem <= MemtoReg_inst1_EX;
			pcPlus1_Mem <= pcPlus1_EX; 

            Branch_inst1_Mem <=Branch_inst1_EX ;
            bit26_Mem_inst1 <= bit26_E_inst1 ;
            pcBranch_Mem_inst1 <= pcBranch_EX_inst1 ;
            pc_Mem <= pc_EX ; 
            prediction_Mem_1 <= prediction_EX_1 ;
            Rs_Mem_inst1 <=Rs_EX_inst1 ;
            Rt_Mem_inst1 <= Rt_EX_inst1 ;
          
            end

    end
 
    
endmodule