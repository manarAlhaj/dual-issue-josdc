module IF_ID_Reg (
    input [31:0] instructionFetch,
    input [5:0] pcPlus1F,
    input [5:0] pcF, //propagated pc of the current instruction because it is needed to be used in bpu
    input clk,
    input reset,
    input stall,
    input flush,

    output reg [31:0] instructionDecode,
    output reg [5:0] pcPlus1D,
    output reg [5:0] pcD

);
    always @ (posedge clk, negedge reset) begin
        if (~reset) 
		  begin
            instructionDecode <= 32'b0;
            pcD <= 6'b0;
        end
        else if (flush)
        begin
            instructionDecode <= 32'b0;
            pcD <= 6'b0;
        end
        else if (~stall)
		  begin
            instructionDecode = instructionFetch;
            pcPlus1D = pcPlus1F;
            pcD = pcF;
        end
    end
endmodule 