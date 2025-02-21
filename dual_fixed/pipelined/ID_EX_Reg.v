module ID_EX_Reg (
    input clk, 
    input reset, 
    input MemReadEnDecode,
    input MemWriteEnDecode, 
    input RegWriteEnDecode, 
    input ALUSrcDecode, 
    input stall,
    input RegDstDecode, 
    input [1:0] MemtoRegDecode,
    input [3:0] ALUOpDecode,
    input [4:0] shamtDecode, 
    input [4:0] rdDecode, 
    input [4:0] rtDecode,
    input [4:0] rsDecode,
    input [5:0] pcPlus1D,
    input [31:0] readData1Decode, 
    input [31:0] readData2Decode, 
    input [31:0] immDecode,
	 

    output reg MemReadEnExecute,
    output reg MemWriteEnExecute, 
    output reg RegWriteEnExecute, 
    output reg RegDstExecute, 
	 output reg ALUSrcExecute,
    output reg [1:0] MemtoRegExecute,  
    output reg [3:0] ALUOpExecute,
    output reg [4:0] shamtExecute, 
    output reg [4:0] rdExecute, 
    output reg [4:0] rtExecute,
    output reg [4:0] rsExecute,
    output reg [5:0] pcPlus1EX,
    output reg [31:0] readData1Execute, 
    output reg [31:0] readData2Execute, 
    output reg [31:0] immExecute
);

    always @ (posedge clk , negedge reset) begin
        if (~reset) begin
          
            MemReadEnExecute    <= 0;
            MemWriteEnExecute   <= 0;
            RegWriteEnExecute   <= 0;
				ALUSrcExecute       <=0;
            RegDstExecute       <= 1'b0;
            MemtoRegExecute     <= 2'b0;
            ALUOpExecute        <= 4'b0;
            shamtExecute        <= 5'b0;
            rdExecute           <= 5'b0;
            rtExecute           <= 5'b0;
            rsExecute           <= 5'b0;
            readData1Execute    <= 32'b0;
            readData2Execute    <= 32'b0;
            immExecute          <= 32'b0;
				pcPlus1EX           <=  5'b0; 
        end 
        else if (stall) begin //its inserting a nop instruction in the execute until stall is resolved.
            
            MemReadEnExecute    <= 0;
            MemWriteEnExecute   <= 0;
            RegWriteEnExecute   <= 0;
            ALUSrcExecute         <=0;
            RegDstExecute       <= 1'b0;
            MemtoRegExecute     <= 2'b0;
            ALUOpExecute        <= 4'b0;
            shamtExecute        <= 5'b0;
            rdExecute           <= 5'b0;
            rtExecute           <= 5'b0;
            rsExecute           <= 5'b0;
            readData1Execute    <= 32'b0;
            readData2Execute    <= 32'b0;
            immExecute          <= 32'b0;
				pcPlus1EX           <=  5'b0; 

        end 
		  else 
		  begin
           
    
            MemReadEnExecute    <= MemReadEnDecode;
            MemWriteEnExecute   <= MemWriteEnDecode;
            RegWriteEnExecute   <= RegWriteEnDecode;
            RegDstExecute       <= RegDstDecode;
				ALUSrcExecute       <=ALUSrcDecode;
            MemtoRegExecute     <= MemtoRegDecode;
            ALUOpExecute        <= ALUOpDecode;
            shamtExecute        <= shamtDecode;
            rdExecute           <= rdDecode;
            rtExecute           <= rtDecode;
            rsExecute           <= rtDecode;
            readData1Execute    <= readData1Decode;
            readData2Execute    <= readData2Decode;
            immExecute          <= immDecode;
				pcPlus1EX           <= pcPlus1D; 
        end
    end

endmodule
