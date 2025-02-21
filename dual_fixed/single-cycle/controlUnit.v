module controlUnit(opcode, funct, RegDst, Branch, MemReadEn, MemtoReg,
				   ALUOp, MemWriteEn, RegWriteEn, ALUSrc,JUMP,sign_ext, PCsrc);
	
input[5:0] opcode, funct;
output reg MemReadEn,
				 MemWriteEn, RegWriteEn, ALUSrc,JUMP, Branch, PCsrc;
output reg [1:0] RegDst, MemtoReg; 
output reg [3:0] ALUOp;
output reg sign_ext;
//R-type
parameter OPCODE_R_TYPE = 6'b000000;
parameter FUNCT_ADD  = 6'b100000; // ADD
parameter FUNCT_SUB  = 6'b100010; // SUB
parameter FUNCT_AND  = 6'b100100; // AND
parameter FUNCT_OR   = 6'b100101; // OR
parameter FUNCT_XOR  = 6'b100110; // XOR
parameter FUNCT_NOR  = 6'b100111; // NOR
parameter FUNCT_SLT  = 6'b101010; // SLT
parameter FUNCT_JR   = 6'b001000; // JR
parameter FUNCT_SLL  = 6'b000000; // SLL
parameter FUNCT_SRL  = 6'b000010; // SRL
parameter FUNCT_SGT  = 6'b101011; // SGT 

//I-type
parameter OPCODE_LW    = 6'b100011; // LW
parameter OPCODE_SW    = 6'b101011; // SW
parameter OPCODE_BEQ   = 6'b000100; // BEQ
parameter OPCODE_BNE   = 6'b000101; // BNE
parameter OPCODE_ADDI  = 6'b001000; // ADDI
parameter OPCODE_ORI   = 6'b001101; // ORI
parameter OPCODE_XORI  = 6'b001110; // XORI
parameter OPCODE_ANDI  = 6'b001100; // ANDI
parameter OPCODE_SLTI  = 6'b001010; // SLTI

//J-type
parameter OPCODE_J     = 6'b000010; // J
parameter OPCODE_JAL   = 6'b000011; // JAL

always @(*)
 
	begin
	
		RegDst = 2'b0; 
		Branch = 1'b0; 
		MemReadEn = 1'b0; 
		MemtoReg = 2'b0;
		MemWriteEn = 1'b0; 
		RegWriteEn = 1'b0; 
		ALUSrc = 1'b0;
		JUMP=1'b0; 
		PCsrc = 1'b0;
		ALUOp = 4'b0; 
		sign_ext=0;

	case(opcode)
	
		OPCODE_R_TYPE: 
		begin
				
				RegDst = 2'b01;
				Branch = 1'b0;
				MemReadEn = 1'b0;
				MemtoReg = 2'b0;
				MemWriteEn = 1'b0;
				RegWriteEn = 1'b1;
				ALUSrc = 1'b0;
				JUMP=1'b0;
				PCsrc = 1'b0;
				case(funct)
					//R-operations
					FUNCT_ADD: ALUOp=4'b0000;
					FUNCT_SUB: ALUOp=4'b0001;
					FUNCT_AND: ALUOp=4'b0010;
					FUNCT_OR:  ALUOp=4'b0011;
					FUNCT_XOR: ALUOp=4'b0100;
					FUNCT_NOR: ALUOp=4'b0101;
					FUNCT_SLT: ALUOp=4'b0110;
					FUNCT_SLL: ALUOp=4'b0111;
					FUNCT_SRL: ALUOp=4'b1000;
					FUNCT_SGT: ALUOp=4'b1001;
					
					FUNCT_JR:
						begin 
							JUMP = 1'b0;
							RegWriteEn = 1'b0;
							PCsrc = 1'b1;
						end
					default: ; //avoid latches
					endcase
					
				end 
				
		OPCODE_LW: 
			begin
			ALUOp=4'b0000;
			MemReadEn = 1'b1;
			MemtoReg = 2'b01;
			RegWriteEn = 1'b1;
			ALUSrc = 1'b1;
			end
			
		OPCODE_SW: 
			begin
			ALUOp=4'b0000;
			MemReadEn = 1'b0;
			MemtoReg = 2'b00;
			MemWriteEn = 1'b1;
			RegWriteEn = 1'b0;
			ALUSrc = 1'b1;
			end
		
		OPCODE_ADDI: 
			begin
			ALUOp=4'b0000;
			RegWriteEn = 1'b1;
			ALUSrc = 1'b1;
			sign_ext=1'b1;
			end
			
		OPCODE_ORI: 
			begin
			ALUOp=4'b0011;
			RegWriteEn = 1'b1;
			ALUSrc = 1'b1;
			end
		OPCODE_XORI: 
			begin
			ALUOp=4'b0100;
			RegWriteEn = 1'b1;
			ALUSrc = 1'b1;
			end
		OPCODE_ANDI: 
			begin
			ALUOp=4'b0010;
			RegWriteEn = 1'b1;
			ALUSrc = 1'b1;
			end
		OPCODE_SLTI: 
			begin
			ALUOp=4'b0110;
			RegWriteEn = 1'b1;
			ALUSrc = 1'b1;
			sign_ext=1'b1;
			end	
		
		OPCODE_J:
			begin
			JUMP=1'b1;
			PCsrc = 1'b1;
			end
		OPCODE_JAL: 
			begin
			PCsrc = 1'b1;
			JUMP=1'b1;
			RegWriteEn = 1'b1;
			RegDst = 2'b10;
			MemtoReg = 2'b10;	
			end
		OPCODE_BEQ :
		begin
		Branch = 1'b1;
		ALUOp=4'b0001;
		end
		OPCODE_BNE : 
		begin
		ALUOp=4'b0001;
		Branch = 1'b1;
		end
		
				default: ;	
		endcase	
		end 
		
		endmodule
		