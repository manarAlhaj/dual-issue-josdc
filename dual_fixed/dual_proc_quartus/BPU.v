module BPU (
    clk, reset, branch1, branch2, branch_taken1, branch_taken2,
    pc1, pc2, pcM1, pcM2, nextPC, 
    prediction1, prediction2, instMemPred
);
    // Inputs
    input clk, reset;
    input branch1, branch2;            // Branch signals for the two instructions
    input branch_taken1, branch_taken2;// Whether the branches were taken or not
    input [7:0] pc1, pc2;            // Program counters for the two instructions
    input [7:0] pcM1, pcM2;          // PCs for instructions in Memory stage
    input [7:0] nextPC;              // Next PC for instruction memory prediction

    // Outputs
    output reg prediction1, prediction2, instMemPred; // Prediction signals

    // Branch History Table (BHT) - 256 entries, 2-bit saturating counters
    reg [1:0] BHT [0:255];

    // Indexes for accessing the BHT
    wire [7:0] index1 = pc1[7:0];
    wire [7:0] index2 = pc2[7:0];
    wire [7:0] indexM1 = pcM1[7:0];
    wire [7:0] indexM2 = pcM2[7:0];
    wire [7:0] predIndex = nextPC[7:0];

    // Prediction logic for the first branch
    always @(*) begin
        case (BHT[index1])
            2'b11: prediction1 = 1'b1; // Strongly Taken
            2'b10: prediction1 = 1'b1; // Weakly Taken
            2'b01: prediction1 = 1'b0; // Weakly Not Taken
            2'b00: prediction1 = 1'b0; // Strongly Not Taken
            default: prediction1 = 1'b0;
        endcase
    end

    // Prediction logic for the second branch
    always @(*) begin
        case (BHT[index2])
            2'b11: prediction2 = 1'b1;
            2'b10: prediction2 = 1'b1;
            2'b01: prediction2 = 1'b0;
            2'b00: prediction2 = 1'b0;
            default: prediction2 = 1'b0;
        endcase
    end

    // Prediction logic for instruction memory (nextPC)
    always @(*) begin
        case (BHT[predIndex])
            2'b11: instMemPred = 1'b1;
            2'b10: instMemPred = 1'b1;
            2'b01: instMemPred = 1'b0;
            2'b00: instMemPred = 1'b0;
            default: instMemPred = 1'b0;
        endcase
    end

    // Update BHT based on resolved branches
    always @(posedge clk or negedge reset) begin
        integer i;
        if (~reset) begin
            // Initialize BHT to Weakly Not Taken (2'b01)
            for (i = 0; i < 256; i = i + 1)
                BHT[i] <= 2'b01;
        end else begin
            // Update first branch's BHT entry
            if (branch1) begin
                case (BHT[indexM1])
                    2'b11: BHT[indexM1] <= branch_taken1 ? 2'b11 : 2'b10;
                    2'b10: BHT[indexM1] <= branch_taken1 ? 2'b11 : 2'b01;
                    2'b01: BHT[indexM1] <= branch_taken1 ? 2'b10 : 2'b00;
                    2'b00: BHT[indexM1] <= branch_taken1 ? 2'b01 : 2'b00;
                endcase
            end
            // Update second branch's BHT entry
            if (branch2) begin
                case (BHT[indexM2])
                    2'b11: BHT[indexM2] <= branch_taken2 ? 2'b11 : 2'b10;
                    2'b10: BHT[indexM2] <= branch_taken2 ? 2'b11 : 2'b01;
                    2'b01: BHT[indexM2] <= branch_taken2 ? 2'b10 : 2'b00;
                    2'b00: BHT[indexM2] <= branch_taken2 ? 2'b01 : 2'b00;
                endcase
            end
        end
    end
endmodule