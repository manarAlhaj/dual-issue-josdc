module branch_predictor (
    input clk,
    input reset,
    input branch,       
    input [5:0] pc,     
    input branch_taken, 
    output reg prediction   
);

    reg [1:0] BHT [0:63];
	 
    wire [5:0] index = pc[5:0];


    always @(*) begin
        case (BHT[index])
            2'b11, 2'b10: prediction = 1'b1; // Strongly/Weakly Taken
            2'b01, 2'b00: prediction = 1'b0; // Weakly/Strongly Not Taken
            default: prediction = 1'b0;
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            integer i;
            for (i = 0; i < 256; i = i + 1) begin
                BHT[i] <= 2'b00; 
            end
        end else if (branch) begin
            case (BHT[index])
                2'b11: BHT[index] <= branch_taken ? 2'b11 : 2'b10;
                2'b10: BHT[index] <= branch_taken ? 2'b11 : 2'b01;
                2'b01: BHT[index] <= branch_taken ? 2'b10 : 2'b00;
                2'b00: BHT[index] <= branch_taken ? 2'b01 : 2'b00;
            endcase
        end
    end

endmodule
