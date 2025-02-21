module ForwardingUnit(
    // Instruction 1 inputs
    input[4:0] Rd_mem_inst1,      // Destination register of inst1 in MEM stage
    input[4:0] Rd_WB_inst1,       // Destination register of inst1 in WB stage
    input[4:0] Rs_EX_inst1,       // Source register 1 of inst1 in EX stage
    input[4:0] Rt_EX_inst1,       // Source register 2 of inst1 in EX stage
    input RegWrite_mem_inst1,      // Register write control for inst1 in MEM
    input RegWrite_WB_inst1,       // Register write control for inst1 in WB
    
    // Instruction 2 inputs
    input[4:0] Rd_mem_inst2,      // Destination register of inst2 in MEM stage
    input[4:0] Rd_WB_inst2,       // Destination register of inst2 in WB stage
    input[4:0] Rs_EX_inst2,       // Source register 1 of inst2 in EX stage
    input[4:0] Rt_EX_inst2,       // Source register 2 of inst2 in EX stage
    input RegWrite_mem_inst2,      // Register write control for inst2 in MEM
    input RegWrite_WB_inst2,       // Register write control for inst2 in WB
    
    // Output forwarding control signals
    output reg [2:0] forwardA_inst1,  // Forward control for Rs of inst1
    output reg [2:0] forwardB_inst1,  // Forward control for Rt of inst1
    output reg [2:0] forwardA_inst2,  // Forward control for Rs of inst2
    output reg [2:0] forwardB_inst2   // Forward control for Rt of inst2
);
    // Each value indicates which stage and instruction to forward from
    localparam FROM_WB_INST1  = 3'b100;  // Forward from Writeback stage, instruction 1
    localparam FROM_MEM_INST1 = 3'b010;  // Forward from Memory stage, instruction 1
    localparam FROM_MEM_INST2 = 3'b001;  // Forward from Memory stage, instruction 2
    localparam FROM_WB_INST2  = 3'b011;  // Forward from Writeback stage, instruction 2
    localparam NO_FORWARD     = 3'b000;  // No forwarding needed


    always @(*) 
	 begin : FU

        // Default: no forwarding needed
        forwardA_inst1 = NO_FORWARD;
        forwardB_inst1 = NO_FORWARD;
        forwardA_inst2 = NO_FORWARD;
        forwardB_inst2 = NO_FORWARD;

        // Forwarding logic for instruction 1's Rs (forwardA_inst1)
if (RegWrite_mem_inst2 && (Rd_mem_inst2 != 0) && (Rd_mem_inst2 == Rs_EX_inst1))
forwardA_inst1 = FROM_MEM_INST2;
else if (RegWrite_mem_inst1 && (Rd_mem_inst1 != 0) && (Rd_mem_inst1 == Rs_EX_inst1))
forwardA_inst1 = FROM_MEM_INST1;
else if (RegWrite_WB_inst1 && (Rd_WB_inst1 != 0) && (Rd_WB_inst1 == Rs_EX_inst1))
forwardA_inst1 = FROM_WB_INST1;
else if (RegWrite_WB_inst2 && (Rd_WB_inst2 != 0) && (Rd_WB_inst2 == Rs_EX_inst1))
forwardA_inst1 = FROM_WB_INST2;


// Forwarding logic for instruction 2's Rs (forwardA_inst2)
if (RegWrite_mem_inst2 && (Rd_mem_inst2 != 0) && (Rd_mem_inst2 == Rs_EX_inst2))
forwardA_inst2 = FROM_MEM_INST2;
else if (RegWrite_mem_inst1 && (Rd_mem_inst1 != 0) && (Rd_mem_inst1 == Rs_EX_inst2))
forwardA_inst2 = FROM_MEM_INST1;
else if (RegWrite_WB_inst1 && (Rd_WB_inst1 != 0) && (Rd_WB_inst1 == Rs_EX_inst2))
forwardA_inst2 = FROM_WB_INST1;
else if (RegWrite_WB_inst2 && (Rd_WB_inst2 != 0) && (Rd_WB_inst2 == Rs_EX_inst2))
forwardA_inst2 = FROM_WB_INST2;

        // Forwarding logic for instruction 1's Rt (forwardB_inst1)
        if (RegWrite_mem_inst2 && (Rd_mem_inst2 != 0) && (Rd_mem_inst2 == Rt_EX_inst1))
            forwardB_inst1 = FROM_MEM_INST2;
        else if (RegWrite_mem_inst1 && (Rd_mem_inst1 != 0) && (Rd_mem_inst1 == Rt_EX_inst1))
            forwardB_inst1 = FROM_MEM_INST1;
        else if (RegWrite_WB_inst1 && (Rd_WB_inst1 != 0) && (Rd_WB_inst1 == Rt_EX_inst1))
            forwardB_inst1 = FROM_WB_INST1;
        else if (RegWrite_WB_inst2 && (Rd_WB_inst2 != 0) && (Rd_WB_inst2 == Rt_EX_inst1))
            forwardB_inst1 = FROM_WB_INST2;



        // Forwarding logic for instruction 2's Rt (forwardB_inst2)
        if (RegWrite_mem_inst2 && (Rd_mem_inst2 != 0) && (Rd_mem_inst2 == Rt_EX_inst2))
            forwardB_inst2 = FROM_MEM_INST2;
        else if (RegWrite_mem_inst1 && (Rd_mem_inst1 != 0) && (Rd_mem_inst1 == Rt_EX_inst2))
            forwardB_inst2 = FROM_MEM_INST1;
        else if (RegWrite_WB_inst1 && (Rd_WB_inst1 != 0) && (Rd_WB_inst1 == Rt_EX_inst2))
            forwardB_inst2 = FROM_WB_INST1;
        else if (RegWrite_WB_inst2 && (Rd_WB_inst2 != 0) && (Rd_WB_inst2 == Rt_EX_inst2))
            forwardB_inst2 = FROM_WB_INST2;
    end
	 
	 endmodule
	 