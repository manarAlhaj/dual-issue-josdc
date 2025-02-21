module pht (
input clk,
input reset,
input [5:0] pcFetch, //pc in fetch stage
input [5:0] pcBranchD, // pc of the branch instruction calculated in decode stage
input branch_update, // control signal to update the pht if its a branch instruction
input actual_outcome,  // prediction actual outcome
input is_branch, 
input [5:0] ghr_E,
output reg prediction,
output reg [5:0] ghr_F
); 

reg [1:0] PHtable [63:0];

integer i;

wire [5:0] ghr_F_internal;

GlobalHistoryRegister GHR(
    clk,       
    reset,       
    actual_outcome,
	branch_update,
    ghr_F_internal);

always @* begin
    ghr_F = ghr_F_internal;
end

always @(posedge clk, posedge reset) begin  //initilize to weakly not taken
	if(reset) begin
	   for(i=0; i < 32; i = i + 1) begin
			PHtable[i] = 2'b01;
		end
	end
	else if (branch_update) begin
        // Update the PHT
        if (actual_outcome) begin
            // Branch taken increment the counter if not strongly taken
            if (~(PHtable[(ghr_E)^(pcBranchD)] == 2'b11))
                PHtable[(ghr_E)^(pcBranchD)] = PHtable[(ghr_E)^(pcBranchD)] + 2'b01;
        end else begin
            // Branch not taken decrement the counter if not strongly not taken
            if (~(PHtable[(ghr_E)^(pcBranchD)] == 2'b00))
                PHtable[(ghr_E)^(pcBranchD)] = PHtable[(ghr_E)^(pcBranchD)] - 2'b01;
        end
    end

end

always @(*) begin
    // Determine prediction only if it's a branch instruction
    if (is_branch) begin
		 case(PHtable[(ghr_F_internal)^(pcFetch)])
			2'b00 : prediction=0;
			2'b01 : prediction=0;
			2'b10 : prediction=1;
			2'b11 : prediction=1;
			endcase
		end
    
	 else prediction = 0;  // Default
    
end

endmodule 