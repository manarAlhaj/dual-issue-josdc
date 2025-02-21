module BPU (
    input  wire clk,
    input  wire reset,
    input  wire [7:0] PC_inst1_F,
    input  wire [7:0] PC_inst1_E,
    input  wire actual_outcome_inst1,       
    input  wire Branch_inst1,
    input  wire [7:0] PC_inst2_F,
    input  wire [7:0] PC_inst2_E,   
    input  wire actual_outcome_inst2,       
    input  wire Branch_inst2,
    
    output wire prediction_inst1,
    output wire prediction_inst2          
);

// Branch History Table (BHT) - stores 2-bit counters
    reg [1:0] bht [255:0]; 
   
    assign prediction_inst1 = (bht[PC_inst1_F] >= 2'b10);
    assign prediction_inst2 = (bht[PC_inst2_F] >= 2'b10);

    function [1:0] update_counter;
        input [1:0] current_state;
        input actual_outcome;
        begin
            case (current_state)
                2'b00: update_counter = actual_outcome ? 2'b01 : 2'b00;
                2'b01: update_counter = actual_outcome ? 2'b10 : 2'b00;
                2'b10: update_counter = actual_outcome ? 2'b11 : 2'b01;
                2'b11: update_counter = actual_outcome ? 2'b11 : 2'b10;
            endcase
        end
    endfunction
	 
	
    // Update logic for both branches
    always @(posedge clk , negedge reset) begin :BPU
	    integer i;
        if (~reset) begin
            for (i = 0; i < 256; i = i + 1) begin
                bht[i] <= 2'b01;
            end
        end
        else 
		  begin
        
            if (Branch_inst1) 
				begin
                bht[PC_inst1_E] <= update_counter(bht[PC_inst1_E], actual_outcome_inst1);
            end
            
            if (Branch_inst2) 
				begin
                bht[PC_inst2_E] <= update_counter(bht[PC_inst2_E], actual_outcome_inst2);
            end
        end
    end

endmodule
