module gshare_branch_predictor (
    input clk,
    input reset,
    input branch,          // Is it a branch instruction
    input [5:0] pc,         
    input branch_taken,    // Answer of XNOR gate
    output reg prediction  // Taken or not taken
);

    // Size of table = size of instruction memory 
    reg [1:0] taken_counter [0:63];       // Counter for taken 
    reg [1:0] not_taken_counter [0:63];   // Counter for not taken 
    reg [5:0] global_history;             
    wire [5:0] gshare_index;

    assign gshare_index = pc ^ global_history; 
	   
    always @(*)
	 begin

        if (global_history[0])
			begin
            if (taken_counter[gshare_index] >= 2'b10) 
                prediction = 1;
				else 	 
					prediction = 0;
			end 		
		  else
           begin
			  
            if (not_taken_counter[gshare_index] < 2'b10) 
                prediction = 1;
				else 
					 prediction = 0;
				end	 

    end

	integer i;
    always @(posedge clk or negedge reset) 
	 begin
		
        if (~reset) 
		  begin
		  
            for (i = 0; i < 64; i = i + 1)
					begin
						taken_counter[i] <= 2'b01;      // Start with weak not taken
						not_taken_counter[i] <= 2'b10;  // Start with weak taken
					end
					
					global_history <= 6'b0; 
        end 
		  
		  else if (branch) 
		  begin
            if (branch_taken) 
				begin
                if (global_history[0]) 
					 begin
                    // Update taken counter
                    if (taken_counter[gshare_index] < 2'b11)
                        taken_counter[gshare_index] <= taken_counter[gshare_index] + 2'b01;
						  else;	
                end 
					 else 
						begin
                    // Update not taken counter
							if (not_taken_counter[gshare_index] > 2'b00)
                        not_taken_counter[gshare_index] <= not_taken_counter[gshare_index] - 2'b01;
							else;
						end
						
					end 
					else 
						begin
                if (global_history[0])
					 begin
                    // Update taken counter
                    if (taken_counter[gshare_index] > 2'b00)
                        taken_counter[gshare_index] <= taken_counter[gshare_index] - 2'b01;
							else; 	
                end else begin
                    // Update not taken counter
                    if (not_taken_counter[gshare_index] < 2'b11)
                        not_taken_counter[gshare_index] <= not_taken_counter[gshare_index] + 2'b01;
							else;		
                end
            end
            // Shift global history and append branch outcome
            global_history <= {global_history[4:0], branch_taken};
        end
    end
endmodule
