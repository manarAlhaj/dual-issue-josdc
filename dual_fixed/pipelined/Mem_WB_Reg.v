module Mem_WB_Reg (
    input clk,
    input reset,
    input [31:0] memoryReadDataMem,
    input [31:0] AluResultMem,
    input [4:0] rd_or_rt_M,
    input [1:0] MemtoRegMem,
    input RegWriteMem,
    input [5:0] pcPlus1Mem,
	 input RegDstMem,
   
    output reg [31:0] memoryReadDataWB,
    output reg [31:0] AluResultWB,
    output reg [4:0] rd_or_rt_WB,
    output reg [1:0] MemtoRegWB,
    output reg RegWriteWB,
    output reg [5:0] pcPlus1WB,
	 output reg RegDstWB
);

    always @(posedge clk , negedge reset) begin
        if (~reset)
		  begin
            memoryReadDataWB <= 32'b0;
            AluResultWB      <= 32'b0;
            rd_or_rt_WB      <= 5'b0;
            MemtoRegWB       <= 2'b0;
            RegWriteWB       <= 1'b0;
            
				pcPlus1WB        <= 5'b0;
				RegDstWB         <= 1'b0;
        end
		  else
		  begin
     
            memoryReadDataWB <= memoryReadDataMem;
            AluResultWB      <= AluResultMem;
            rd_or_rt_WB        <= rd_or_rt_M;
            MemtoRegWB       <= MemtoRegMem;
            RegWriteWB       <= RegWriteMem;
           
				pcPlus1WB        <= pcPlus1Mem;
				RegDstWB         <= RegDstMem;
        end
    end

endmodule

// memoryReadData (32 bits), AluResult (32 bits), rt (5 bits), rd (5 bits), MemtoReg (2 bits), RegWrite (1 bit), jump