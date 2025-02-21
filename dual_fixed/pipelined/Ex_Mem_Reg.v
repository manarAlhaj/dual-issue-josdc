
module Ex_Mem_Reg (
    input clk,
    input reset,
   
    input [31:0] AluOutExecute,
    input [31:0] ReadData2Execute,
    input [4:0] rd_or_rt_E,
    input MemReadExecute,
    input MemWriteExecute,
    input RegWriteExecute,
    input [1:0] MemtoRegExecute,
    input [5:0] pcPlus1EX,
	 input RegDstExecute,
  

    output reg [31:0] AluOutMem,
    output reg [31:0] ReadData2Mem,
    output reg [4:0] rd_or_rt_M,
    output reg MemReadMem,
    output reg MemWriteMem,
    output reg RegWriteMem,
    output reg [1:0] MemtoRegMem,
    output reg [5:0] pcPlus1Mem,
	 output reg RegDstMem

);

    always @(posedge clk , negedge reset) begin
        if (~reset) begin
            
            AluOutMem            <= 32'b0;
            ReadData2Mem         <= 32'b0;
            rd_or_rt_M          <= 5'b0;
          
            MemReadMem           <= 1'b0;
            MemWriteMem          <= 1'b0;
            RegWriteMem          <= 1'b0;
            MemtoRegMem          <= 2'b0;
				pcPlus1Mem           <=5'b0;
				RegDstMem            <= 1'b0;
        end 
		  else 
		  begin
            
            AluOutMem            <= AluOutExecute;
            ReadData2Mem         <= ReadData2Execute;
            rd_or_rt_M           <= rd_or_rt_E;
					
            MemReadMem           <= MemReadExecute;
            MemWriteMem          <= MemWriteExecute;
            RegWriteMem          <= RegWriteExecute;
            MemtoRegMem          <= MemtoRegExecute;
				pcPlus1Mem            <= pcPlus1EX;
				RegDstMem             <= RegDstExecute;
        end
    end

endmodule
// branchAdderResult (6 bits), AluOut (32 bits), ReadData2 (32 bits), rd (5 bi5s), rt (5 bits), Zero (1 bit),
// branch, Jump, MemRead, MemWrite, RegWrite (1 bit), MemtoReg (2 bits)