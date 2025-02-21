module processor(clk, reset, PC);

	
input clk,reset;
output[7:0] PC;
	
wire [31:0] instruction, writeData, readData1, readData2, extImm, ALUin2, ALUResult, memoryReadData,WB_MUX_OUT;
wire [15:0] imm;
wire [5:0] opCode, funct;
wire [7:0] nextPC, PCPlus1;
wire [4:0] rs, rt, rd, writeRegister;
wire [3:0] ALUOp;
wire MemReadEn, MemWriteEn, RegWriteEn, ALUSrc, zero,JUMP,LINK,sign_ext,OVF,Branch_type,Branch,PCsrc, BRANCH_SIG, memory_out_of_bound, mem_flag, memory_out_of_bound_checked;
wire[1:0] RegDst, MemtoReg; 
wire [7:0]jump_r_address,adderResult, PC_Branch_out, jump_out;
wire [4:0]shamt;

assign opCode = instruction[31:26];
assign rd = instruction[15:11];
assign rs = instruction[25:21];
assign rt = instruction[20:16]; 
assign imm = instruction[15:0];
assign shamt = instruction[10:6];
assign funct = instruction[5:0];
assign jump_r_address = readData1[7:0];// jump_r should read the address from rs reg which is read over readData1
	
	programCounter pc(.clk(clk), .reset(reset), .PCin(nextPC), .PCout(PC));
	
	adder PCAdder(.in1(PC), .in2(8'b1), .out(PCPlus1));	
	
	instructionMemory IM(.address(nextPC), .clock(clk), .q(instruction));
	
	controlUnit CU(.opcode(opCode), .funct(funct), 
				      .RegDst(RegDst), .Branch(Branch), .MemReadEn(MemReadEn), .MemtoReg(MemtoReg),
				      .ALUOp(ALUOp), .MemWriteEn(MemWriteEn), .RegWriteEn(RegWriteEn), .ALUSrc(ALUSrc), .JUMP(JUMP), .sign_ext(sign_ext), .PCsrc(PCsrc));
	
	mux3to1 #(5) RFMux(.in1(rt), .in2(rd),.in3(5'b11111),.S(RegDst), .out(writeRegister));  
	
	registerFile RF(.clk(clk), .rst(reset), .we(RegWriteEn), 
					    .readRegister1(rs), .readRegister2(rt), .writeRegister(writeRegister),
					    .writeData(writeData), .readData1(readData1), .readData2(readData2));
						 
	SignExtender SignExtend(.immediate(imm), .sign_ext(sign_ext) , .ext_immediate(extImm));
	
	mux2x1 #(32) ALUMux(.in1(readData2), .in2(extImm), .s(ALUSrc), .out(ALUin2));
	
	ALU alu(.ALUop(ALUOp), .op1(readData1), .op2(ALUin2), .shamt(shamt), .result(ALUResult),.OVF(OVF) ,.zero(zero), .memory_out_of_bound(memory_out_of_bound));
	
	OR_GATE_3 lw_sw_check (MemReadEn, MemWriteEn, 0, mem_flag);
	
	ANDGate memory_bounds (mem_flag, memory_out_of_bound, memory_out_of_bound_checked);
	
	XNOR_GATE branch_xnor (.in1(~zero), .in2(instruction[26]), .out(Branch_type)); // xnor just to differ between beq/ bne based on opcode's lsb
	
	ANDGate branchAnd(.in1(Branch_type), .in2(Branch), .out(BRANCH_SIG));
	
	mux2x1 #(8) PC_branch_mux (.in1(PCPlus1), .in2(adderResult), .s(BRANCH_SIG), .out(PC_Branch_out));
	
	mux2x1 #(8) Jump_jumpR_mux (.in1(jump_r_address), .in2(instruction[7:0]), .s(JUMP), .out(jump_out));
	
	mux2x1 #(8) Final_PC (.in1(PC_Branch_out), .in2(jump_out), .s(PCsrc), .out(nextPC));
	
	adder branchAdder(.in1(PCPlus1), .in2(imm[7:0]), .out(adderResult));
	
	dataMemory DM(.address(ALUResult[7:0]), .clock(~clk), .data(readData2), .rden(MemReadEn), .wren(MemWriteEn), .q(memoryReadData));
	
	mux3to1 #(32) WBMux(.in1(ALUResult), .in2(memoryReadData),.in3({24'b0,PCPlus1}), .S(MemtoReg), .out(writeData)); 

	
endmodule
