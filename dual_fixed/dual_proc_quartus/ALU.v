module ALU (ALUop, op1,op2,shamt,result,OVF);

    input [3:0] ALUop;
    input signed [31:0] op1,op2;
    input [4:0] shamt;
    output reg [31:0] result;
    output reg OVF;
    
     
    always @(*) begin
    
        case(ALUop)
        4'b0000 : result = (op1 + op2); //add
        4'b0001 : result = (op1 - op2); //sub
        4'b0010 : result = (op1 & op2); //and
        4'b0011 : result = (op1 | op2); //or
        4'b0100 : result = (op1 ^ op2); //xor
        4'b0101 : result = ~(op1 | op2); //nor
        4'b0110 : result = (op1 < op2 ) ? 32'b1 : 32'b0; //slt
        4'b0111 : result = (op2 << shamt); //shift left
        4'b1000 : result = (op2 >> shamt); //shift right
        4'b1001 : result = (op1 > op2) ? 32'b1 : 32'b0; //sgt
        default: result = 32'b0; // no operation
        
        endcase
        end

        // not used :3
        // always @ (*) 
        // begin    
        //      zero = (result == 32'b0); 
        // end
        
        //must review later when exceptions are implemented:3
        always @(*) 
        begin
            
            if((result[31] == 1 & op1[31] == 0 & op2[31] == 0) | (result[31] == 0 & op1[31] == 1 & op2[31] == 1))
                OVF = 1;
            else 
                OVF = 0;
        end
    endmodule 