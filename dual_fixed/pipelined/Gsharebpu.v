module gshare_branch_predictor (
    input clk,
    input reset,
    input branch,          // isit a branch inst
    input [5:0] pc,         
    input [5:0] target,    //target address actually 
    input branch_taken,     // answer of xnor gate
    // gshare answers
    output reg prediction,  //taken or not taken // is pre
    output reg [5:0] predicted_target  //to put in pc 
);
    
    //size of table= size of inst mem 
    reg [1:0] taken_counter [0:63];       // Counter for taken
    reg [1:0] not_taken_counter [0:63];   // Counter for not taken 
    reg [5:0] Target_address [0:63];     
    reg [5:0] global_history;             // Most recent is at the LSB

    wire [5:0] gshare_index;
    assign gshare_index = pc ^ global_history;
    
    //initialization 
    always @(*) 
    begin
        //  by default assume not taken unless
        prediction = 0;
        predicted_target = pc + 1; 
        
        // if its more taken than not take then assume taken
        if (taken_counter[gshare_index] >= not_taken_counter[gshare_index]) 
        begin
            prediction = 1;
            predicted_target = Target_address[gshare_index];
        end
    end
    
    
    always @(posedge clk or negedge reset) 
    begin
        if (reset) 
        begin
           //clear everthing and initialize all values to 
           // assume initial pattern n t n t n t 
            for (integer i = 0; i < 64; i = i + 1) 
            begin
                taken_counter[i] = 2'b01;      // Start with shallow not taken  
                not_taken_counter[i] = 2'b10;  // start with shallow taken  
                Target_address[i] = 6'b0;     // should i make it pc+1 too or no ?
            end
            global_history = 6'b0; // clear history 
        end
        else if (branch) 
        begin
            // update target address
            Target_address[gshare_index] = target;
            if (branch_taken) 
            begin
                // if anything less than deep taken 
                if (taken_counter[gshare_index] < 2'b11)
                    taken_counter[gshare_index] = taken_counter[gshare_index] + 1;
                // if anything more than deep not taken 
                if (not_taken_counter[gshare_index] > 2'b00)
                    not_taken_counter[gshare_index] = not_taken_counter[gshare_index] - 1;
            end
            else //branch not taken
            begin
                if (taken_counter[gshare_index] > 2'b00)
                    taken_counter[gshare_index] = taken_counter[gshare_index] - 1;

                if (not_taken_counter[gshare_index] < 2'b11)
                    not_taken_counter[gshare_index] = not_taken_counter[gshare_index] + 1;
            end

            global_history = {global_history[4:0], branch_taken};
        end
    end
endmodule
