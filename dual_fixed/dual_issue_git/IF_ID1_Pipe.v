// This is the pipeline between fetch and first decode substage  
module IF_ID1_Pipe (
    input clk,
    input reset,
    input [31:0] inst1_Fetch, // Instruction 1 input
    input [31:0] inst2_Fetch, // Instruction 2 input
    input [7:0] pcF, // PC of instruction 1
    input [7:0] pcPlus1F, // PC of instruction 2
    input [7:0] pcBranchF, // Propagated PC of the current instruction (for branch prediction)
    input [7:0] pcPlus2_F, // PC + 2 for the second instruction
    input [7:0] pcBranchF_inst2,
    input stall_outer, // Stall signal 
	 input flush_F_1,
	 input flush_F_2, 
	
    input predictionF_1, // Branch prediction input
    input predictionF_2, // Branch prediction input

    output reg [7:0] pcPlus2_D,
    output reg [31:0] inst1_Decode,
    output reg [31:0] inst2_Decode,
    output reg [7:0] pcD, 
    output reg [7:0] pcD_inst2,
    output reg [7:0] pcBranchD,
    output reg [7:0] pcBranchD_inst2,
    output reg predictionD_1,
    output reg predictionD_2
);

    always @(posedge clk , negedge reset) begin
    if (~reset) begin
        inst1_Decode <= 32'b0;
        inst2_Decode <= 32'b0;
        pcD <= 8'b0;
        pcD_inst2 <= 8'b0;
        pcPlus2_D <= 8'b0;
        pcBranchD <= 8'b0;
        pcBranchD_inst2 <= 8'b0;
        predictionD_1 <= 1'b0;
        predictionD_2 <= 1'b0;
    end

    // Handle stalls
    else 
    begin
        if (stall_outer) begin
            inst1_Decode <= inst1_Decode;
            pcD <= pcD;
            pcBranchD <= pcBranchD;
            predictionD_1 <= predictionD_1;
            pcPlus2_D <= pcPlus2_D;
        end 

        // Handle flushes (Jump, Branch, JR)
        else if (flush_F_1) begin
            inst1_Decode <= 32'b0;
            pcD <= 8'b0;
            pcD_inst2 <= 8'b0;
            pcPlus2_D <= 8'b0;
            pcBranchD <= 8'b0;
            predictionD_1 <= 1'b0;
        end 
        // Normal pipeline behavior
        else begin
            inst1_Decode <= inst1_Fetch;
            pcD <= pcF;
            pcPlus2_D <= pcPlus2_F;
            pcBranchD <= pcBranchF;
            predictionD_1 <= predictionF_1;
        end

        if (stall_outer) begin
            inst2_Decode <= inst2_Decode;
            pcD_inst2 <= pcD_inst2;
            pcBranchD_inst2 <=pcBranchD_inst2 ;
            predictionD_2 <= predictionD_2;
        end 

        // Handle flushes (Jump, Branch, JR)
        else if (flush_F_2)	
        begin
            inst2_Decode <= 32'b0;
            pcD_inst2 <= 8'b0;
            predictionD_2 <= 1'b0;
            pcBranchD_inst2 <= 8'b0;
        end
        // Normal pipeline behavior
        else begin
            inst2_Decode <= inst2_Fetch;
            pcD_inst2 <= pcPlus1F;
            pcBranchD_inst2 <= pcBranchF_inst2;
            predictionD_2 <= predictionF_2;
        end
    end
    end

endmodule