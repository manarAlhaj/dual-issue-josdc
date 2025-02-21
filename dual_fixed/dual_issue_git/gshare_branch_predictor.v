module gshare_branch_predictor (
    input clk,
    input reset,
    input branch_1,
    input branch_2,
    input [7:0] pc_fetch,
    input [7:0] pc2_fetch,
    input [7:0] pc_execute,
    input [7:0] pc2_execute, 
    input branch_taken_1,
    input branch_taken_2,
    output reg prediction_1,
    output reg prediction_2 
);

    // Branch History Tables
    reg [1:0] taken_counter [0:255];
	 reg [1:0] not_taken_counter [0:255];
	 reg [7:0] global_history_1;
    reg [7:0] global_history_2;

    // Index calculations (PC XOR global history for true gshare behavior)
    wire [7:0] index_F = pc_fetch ^ global_history_1;
    wire [7:0] index2_F = pc2_fetch ^ global_history_2;
    wire [7:0] index_E = pc_execute ^ global_history_1;
    wire [7:0] index2_E = pc2_execute ^ global_history_2;

    // Prediction logic for instruction 1 (fixed)
    always @(*) begin
        prediction_1 = 0;
        if (global_history_1[0]) begin
            prediction_1 = (not_taken_counter[index_F] >= 2'b10);
        end else begin
            prediction_1 = (taken_counter[index_F] >= 2'b10);
        end
    end

    // Prediction logic for instruction 2 (fixed prediction_2 assignments)
    always @(*) begin
        prediction_2 = 0;
        if (global_history_2[0]) begin
            prediction_2 = (not_taken_counter[index2_F] >= 2'b10);
        end else begin
            prediction_2 = (taken_counter[index2_F] >= 2'b10);
        end
    end

    // Update logic (fixed syntax and structure)
    always @(posedge clk or negedge reset) begin : bpu
        integer i;
        if (~reset) begin
            for (i = 0; i < 256; i = i + 1) begin
                taken_counter[i] <= 2'b01;
                not_taken_counter[i] <= 2'b10;
            end
            global_history_1 <= 8'b0;
            global_history_2 <= 8'b0;
        end else begin
            // Handle branch 1
            if (branch_1) begin
                if (branch_taken_1) begin
                    if (global_history_1[0]) begin
                        if (taken_counter[index_E] < 2'b11)
                            taken_counter[index_E] <= taken_counter[index_E] + 2'd1;
                    end else begin
                        if (not_taken_counter[index_E] > 2'b00)
                            not_taken_counter[index_E] <= not_taken_counter[index_E] - 2'd1;
                    end
                end else begin
                    if (global_history_1[0]) begin
                        if (taken_counter[index_E] > 2'b00)
                            taken_counter[index_E] <= taken_counter[index_E] - 2'd1;
                    end else begin
                        if (not_taken_counter[index_E] < 2'b11)
                            not_taken_counter[index_E] <= not_taken_counter[index_E] + 2'd1;
                    end
                end
                global_history_1 <= {global_history_1[6:0], branch_taken_1};
            end

            // Handle branch 2 (mirror of branch_1)
            if (branch_2) begin
                if (branch_taken_2) begin
                    if (global_history_2[0]) begin
                        if (taken_counter[index2_E] < 2'b11)
                            taken_counter[index2_E] <= taken_counter[index2_E] + 2'd1;
                    end else begin
                        if (not_taken_counter[index2_E] > 2'b00)
                            not_taken_counter[index2_E] <= not_taken_counter[index2_E] - 2'd1;
                    end
                end else begin
                    if (global_history_2[0]) begin
                        if (taken_counter[index2_E] > 2'b00)
                            taken_counter[index2_E] <= taken_counter[index2_E] - 2'd1;
                    end else begin
                        if (not_taken_counter[index2_E] < 2'b11)
                            not_taken_counter[index2_E] <= not_taken_counter[index2_E] + 2'd1;
                    end
                end
                global_history_2 <= {global_history_2[6:0], branch_taken_2};
            end
        end
    end

endmodule
