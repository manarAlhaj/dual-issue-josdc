module GlobalHistoryRegister(
    input wire clock,       // Clock signal
    input wire reset,       // Reset signal
    input wire pluhBit,  // Value to set in the GHR
	 input wire is_branch,
    output reg [5:0] GHRFetch     // Global History Register
);
reg [5:0] GHR;

always @(negedge clock ) begin
    if (reset) begin
        // Reset the GHR to all zeros
        GHR <= 0;
    end else begin
        // Shift the GHR to the left
        if (is_branch) GHR <= {GHR[4:0], pluhBit};
    end
end
always @(posedge clock) GHRFetch <= GHR;

endmodule