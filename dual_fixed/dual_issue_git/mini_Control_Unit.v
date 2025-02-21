module mini_Control_Unit
( input [5:0] OPCODE,
  output reg branchF
 
);

parameter OPCODE_BEQ   = 6'b000100; 
parameter OPCODE_BNE   = 6'b000101;

always @(*)
    begin
    if(OPCODE == OPCODE_BEQ || OPCODE == OPCODE_BNE)
        branchF = 1;
    else
        branchF = 0;
    

    end


endmodule 