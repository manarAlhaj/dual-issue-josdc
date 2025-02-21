module gshare_branch_predictor (
    input clk,
    input reset,
    input branch_1,
    input branch_2,       // isit a branch instruction
    input [7:0] pc_fetch, // pc fetch ,where i wanna put my prediction
    input [7:0] pc2_fetch, // pc execute ,what branch i am using  
    
    input[7:0] pc_execute,
    input [7:0] pc2_execute, 

    input branch_taken_1,
    input branch_taken_2,    // answer of xnor gate
    // gshare answers
    output reg prediction_1,
    output reg prediction_2 
    );
    
    //size of table= size of inst mem 
    reg [1:0] taken_counter [0:255];       // Counter for taken 
    reg [1:0] not_taken_counter [0:255];   // Counter for not taken 
    reg [7:0] global_history_1;
    reg [7:0] global_history_2;
    
    
    wire [7:0] index_F;
    wire [7:0] index2_F;
    wire [7:0] index_E;
    wire [7:0] index2_E;

    assign index_F =  pc_fetch;
    assign index2_F = pc2_fetch;
    
    assign index_E = pc_execute;
    assign index2_E = pc2_execute; 



    always @(*)
	 /*
            11  = deep Taken
            10  = shalllow Taken
            01  = shallow Not Taken
            00  = deep Not Taken */ 
    begin
        // Default not taken 
        prediction_1 = 0;

        if (global_history_1[0]) 
        begin
            // If global history is 0, use not taken counter for prediction
            if (not_taken_counter[index_F] < 2'b10) 
                prediction_1 = 0;
					 else 
			    prediction_1 = 1;
        end
		  else
		   begin
            // If global history is 1, use taken counter for prediction
            if (taken_counter[index_F] >= 2'b10) 
                prediction_1 = 1;
					 else 
				prediction_1 = 0;
        end
    end

    
    always @(*)

       begin
           // Default not taken 
           prediction_2 = 0;
   
           if (global_history_2[0]) 
           begin
               // If global history is 0, use not taken counter for prediction
               if (not_taken_counter[index2_F] < 2'b10) 
                   prediction_2 = 0;
                        else 
                   prediction_2 = 1;
           end
             else
              begin
               // If global history is 1, use taken counter for prediction
               if (taken_counter[index2_F] >= 2'b10) 
                   prediction_2 = 1;
                        else 
                   prediction_2 = 0;
           end
       end
    

    always @(posedge clk or negedge reset) begin :loop
		integer i;
        if (~reset) 
        begin 
            for ( i = 0; i < 255; i = i + 1) 
            begin
                taken_counter[i] = 2'b01;      // Start with shallow not taken  
                not_taken_counter[i] = 2'b10;  // Start with shallow taken  
                global_history_1 = 8'b0; 
                global_history_2 = 8'b0;
            end
            
        end
        else if (branch_1) 
        begin
            if (branch_taken_1) 
            begin

                if (global_history_1[0]) // branch taken 
                begin
                    // If history was 1, update taken counter
                    if (taken_counter[index_E] < 2'b11)
                        taken_counter[index_E] = taken_counter[index_E] + 2'b1;
                end
                else 
                begin
                    // If history was 0, update not taken counter
                    if (not_taken_counter[index_E] > 2'b00)
                        not_taken_counter[index_E] = not_taken_counter[index_E] - 2'b1;
                end
            end
            else // branch not taken 
            begin
                if (global_history_1[0]) 
                begin
                    // If history was 1, update taken counter
                    if (taken_counter[index_E] > 2'b00)
                        taken_counter[index_E] = taken_counter[index_E] - 2'b1;
                end
                else 
                begin
                    // If history was 0, update not taken counter
                    if (not_taken_counter[index_E] < 2'b11)
                        not_taken_counter[index_E] = not_taken_counter[index_E] + 2'b1;
                end
            end

            else if (branch_2) 
                begin
                    if (branch_taken_2) 
                    begin
        
                        if (global_history_2[0]) // branch taken 
                        begin
                            // If history was 1, update taken counter
                            if (taken_counter[index2_E] < 2'b11)
                                taken_counter[index2_E] = taken_counter[index2_E] + 2'b1;
                        end
                        else 
                        begin
                            // If history was 0, update not taken counter
                            if (not_taken_counter[index2_E] > 2'b00)
                                not_taken_counter[index2_E] = not_taken_counter[index2_E] - 2'b1;
                        end
                    end
                    else // branch not taken 
                    begin
                        if (global_history_2[0]) 
                        begin
                            // If history was 1, update taken counter
                            if (taken_counter[index2_E] > 2'b00)
                                taken_counter[index2_E] = taken_counter[index2_E] - 2'b1;
                        end
                        else 
                        begin
                            // If history was 0, update not taken counter
                            if (not_taken_counter[index2_E] < 2'b11)
                                not_taken_counter[index2_E] = not_taken_counter[index2_E] + 2'b1;
                        end
                    end  

            global_history_1 = {global_history_1[6:0], branch_taken_1};
            global_history_2 = {global_history_2[6:0], branch_taken_2};
        end
    end
    end
endmodule