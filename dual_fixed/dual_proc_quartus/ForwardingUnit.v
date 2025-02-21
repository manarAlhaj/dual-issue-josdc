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

    // Forwarding control values:
    // 2'b00 - No forwarding (use register file value)
    // 2'b01 - Forward from inst1 MEM stage
    // 2'b10 - Forward from inst2 MEM stage
    // 2'b11 - Forward from WB stage (either inst1 or inst2)

    always @(*) begin
        // Initialize all forwarding controls to no forwarding
        forwardA_inst1 = 3'b00;
        forwardB_inst1 = 3'b00;
        forwardA_inst2 = 3'b00;
        forwardB_inst2 = 3'b00;
        
        // MEMORY STAGE FORWARDING (Higher Priority)
        // Case 3: inst2 MEM to inst1 EX forwarding
        if(RegWrite_mem_inst2 && (Rd_mem_inst2 != 0)) begin
            // Only forward if inst1 MEM isn't already forwarding
            if((Rd_mem_inst2 == Rs_EX_inst1) ) forwardA_inst1 = 3'b010;
            if((Rd_mem_inst2 == Rt_EX_inst1) ) forwardB_inst1 = 3'b010;
        end
        
        // Case 4: inst2 MEM to inst2 EX forwarding
        if(RegWrite_mem_inst2 && (Rd_mem_inst2 != 0)) begin
            // Only forward if inst1 MEM isn't already forwarding
            if((Rd_mem_inst2 == Rs_EX_inst2) ) forwardA_inst2 = 3'b010;
            if((Rd_mem_inst2 == Rt_EX_inst2) ) forwardB_inst2 = 3'b010;
        end

        // Case 1: inst1 MEM to inst1 EX forwarding
        if(RegWrite_mem_inst1 && (Rd_mem_inst1 != 0)) begin
            if((Rd_mem_inst1 == Rs_EX_inst1)&& (forwardA_inst1 == 3'b000) )forwardA_inst1 = 3'b001;
            if((Rd_mem_inst1 == Rt_EX_inst1)&& (forwardB_inst1 == 3'b000) )forwardB_inst1 = 3'b001;
        end
        
        // Case 2: inst1 MEM to inst2 EX forwarding
        if(RegWrite_mem_inst1 && (Rd_mem_inst1 != 0)) begin
            if((Rd_mem_inst1 == Rs_EX_inst2)&& (forwardA_inst2 == 3'b000)) forwardA_inst2 = 3'b001;
            if((Rd_mem_inst1 == Rt_EX_inst2)&& (forwardB_inst2 == 3'b000)) forwardB_inst2 = 3'b001;
        end
        
  
        
        
        // WRITEBACK STAGE FORWARDING (Lower Priority)
          // Case 7: inst2 WB to inst1 EX forwarding
        if(RegWrite_WB_inst2 && (Rd_WB_inst2 != 0)) begin
            // Only forward if no MEM stage forwarding
            if((Rd_WB_inst2 == Rs_EX_inst1) && (forwardA_inst1 == 3'b000)) forwardA_inst1 = 3'b100;
            if((Rd_WB_inst2 == Rt_EX_inst1) && (forwardB_inst1 == 3'b000)) forwardB_inst1 = 3'b100;
        end
        
        // Case 8: inst2 WB to inst2 EX forwarding
        if(RegWrite_WB_inst2 && (Rd_WB_inst2 != 0)) begin
            // Only forward if no MEM stage forwarding
            if((Rd_WB_inst2 == Rs_EX_inst2) && (forwardA_inst2 == 3'b000)) forwardA_inst2 = 3'b100;
            if((Rd_WB_inst2 == Rt_EX_inst2) && (forwardB_inst2 == 3'b000)) forwardB_inst2 = 3'b100;
        end
        
        // Case 5: inst1 WB to inst1 EX forwarding
        if(RegWrite_WB_inst1 && (Rd_WB_inst1 != 0)) begin
            // Only forward if no MEM stage forwarding
            if((Rd_WB_inst1 == Rs_EX_inst1) && (forwardA_inst1 == 3'b000)) forwardA_inst1 = 3'b011;
            if((Rd_WB_inst1 == Rt_EX_inst1) && (forwardB_inst1 == 3'b000)) forwardB_inst1 = 3'b011;
        end
        
        // Case 6: inst1 WB to inst2 EX forwarding
        if(RegWrite_WB_inst1 && (Rd_WB_inst1 != 0)) begin
            // Only forward if no MEM stage forwarding
            if((Rd_WB_inst1 == Rs_EX_inst2) && (forwardA_inst2 == 3'b000)) forwardA_inst2 = 3'b011;
            if((Rd_WB_inst1 == Rt_EX_inst2) && (forwardB_inst2 == 3'b000)) forwardB_inst2 = 3'b011;
        end
        
      
    end
endmodule