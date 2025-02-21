module EX_MEM_inst1Pipe (
    input clk,
    input reset,
    input [31:0] AluOutExecute_inst1,
    input [31:0] ReadData2Execute_inst1,
    input [4:0] dest_reg_inst1_EX,
   
		input [7:0] pc_EX,
    input MemReadEn_inst1_EX,
    input MemWriteEn_inst1_EX,
    input RegWriteEn_inst1_EX,
    input [1:0] MemtoReg_inst1_EX,

    output reg [31:0] AluOutMem_inst1,
    output reg [31:0] ReadData2Mem_inst1,
    output reg [4:0] dest_reg_inst1_Mem,

 
		output reg [7:0] pcM,
    output reg MemReadEn_inst1_Mem,
    output reg MemWriteEn_inst1_Mem,
    output reg RegWriteEn_inst1_Mem,
	
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
				pcM <= 8'b0;

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
				pcM <= pc_EX; 
            end

    end

    
endmodule