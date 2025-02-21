module dual_issue_processor (
    input clk,
    input reset,
    output reg [7:0] PC
);


wire [7:0] pcPlus2_D, pcD, pcD_inst2, pcBranchD_inst1, pcBranchD_inst2;

//all instruction 1 signals 
wire [5:0] opcode_inst1, funct_inst1;
wire [31:0] inst1_Fetch, inst1_Decode ,instruction1Decode;
wire [31:0] readData1_inst1, readData2_inst1;

assign opcode_inst1 = inst1_Decode[31:26];
assign funct_inst1 = inst1_Decode[5:0];

wire MemReadEn_inst1_D, MemWriteEn_inst1_D, RegWriteEn_inst1_D, ALUSrc_inst1_D,JUMP_inst1_D, Branch_inst1_D,PCsrc_inst1_D, sign_ext_inst1_D;

wire [1:0] RegDst_inst1_D, MemtoReg_inst1_D;
wire [3:0] ALUOp_inst1_D; 
wire [4:0] Rs_D_inst1, Rt_D_inst1, Rd_D_inst1 ,writeRegister_inst1;

//all instruction 2 signals 
wire [5:0] opcode_inst2, funct_inst2;
wire [31:0] inst2_Fetch, inst2_Decode, instruction2Decode;
wire [31:0] readData1_inst2, readData2_inst2;

assign opcode_inst2 = inst2_Decode[31:26];
assign funct_inst2 = inst2_Decode[5:0];


wire [3:0] ALUOp_inst2_D;

wire  MemWriteEn_inst2_D, RegWriteEn_inst2_D, ALUSrc_inst2_D, JUMP_inst2_D, Branch_inst2_D, PCsrc_inst2_D,sign_ext_inst2_D, 
NewJump_inst2, NewpcSource_inst2 , MemReadEn_inst2_D ;
wire [1:0 ] MemtoReg_inst2_D, RegDst_inst2_D ;

wire [4:0] Rs_D_inst2, Rt_D_inst2, Rd_D_inst2, writeRegister_inst2;

wire predictionF_1 ,predictionF_2;
reg [31:0] selected_inst1_Fetch, selected_inst2_Fetch; 

wire [4:0] shamt_inst1 , shamt_inst2;
wire[15:0] immediate_inst1, immediate_inst2;
wire [31:0] extendedImmediate_inst1, extendedImmediate_inst2;

wire [31:0]writeData_inst2;
wire outer_depend;
wire dep_upper_upper, dep_upper_lower, dep_lower_upper, dep_lower_lower, bit26_D_inst1, bit26_D_inst2;
    
wire [4:0] Rd_EX_inst1, Rs_EX_inst1,Rt_EX_inst1, shamt_inst1_EX;
wire [7:0] pc_EX, pcE_inst2 , pcBranch_EX_inst1; 
wire [31:0] readData1_EX_inst1, Imm_EX_inst1; 

wire  MemReadEn_inst1_EX, MemWriteEn_inst1_EX,RegWriteEn_inst1_EX,ALUSrc_inst1_EX, Branch_inst1_EX, PCsrc_inst1_EX;
wire [1:0]MemtoReg_inst1_EX, RegDst_inst1_EX ;
wire [3:0]ALUOp_inst1_EX;
wire [7:0] pcPlus1_Mem, pcPlus1_WB; 
wire predictionD_1, predictionD_2, prediction_EX_1;

wire [4:0]Rd_EX_inst2, Rs_EX_inst2, Rt_EX_inst2 , shamt_inst2_EX;
wire [7:0] pcBranch_EX_inst2, pcPlus2_EX;
wire [31:0]readData1_EX_inst2, readData2_EX_inst2,Imm_EX_inst2;
wire prediction_EX_2,MemReadEn_inst2_EX, MemWriteEn_inst2_EX, RegWriteEn_inst2_EX, ALUSrc_inst2_EX , Branch_inst2_EX, PCsrc_inst2_EX;
wire [1:0]MemtoReg_inst2_EX, RegDst_inst2_EX;
wire [3:0] ALUOp_inst2_EX;

wire OVF1, OVF2;
wire [31:0] ALU_inst2_in1, ALU_inst2_in2;
wire equal_inst1, equal_inst2, bit26_E_inst1, bit26_E_inst2, actual_outcome_inst,final_branch_signal ;

wire branch_equal_final, bit_26_final;

wire [31:0] ALU_inst1_in1,ALU_inst1_in2,ALU_INST1_IN2_FINAL,ALU_INST2_IN2_FINAL ;


wire [2:0] forwardA_inst1, forwardB_inst1, forwardA_inst2, forwardB_inst2;

wire[4:0]dest_reg_inst1_EX, dest_reg_inst2_EX;
wire [31:0] AluOutExecute_inst1, AluOutExecute_inst2, readData2_EX_inst1, AluOutMem_inst1, ReadData2Mem_inst1, AluOutMem_inst2,ReadData2Mem_inst2;

wire MemReadEn_inst1_Mem, MemWriteEn_inst1_Mem, RegWriteEn_inst1_Mem, MemReadEn_inst2_Mem, MemWriteEn_inst2_Mem,RegWriteEn_inst2_Mem;
wire [1:0]MemtoReg_inst1_Mem, MemtoReg_inst2_Mem; 
wire[7:0]pcPlus2_Mem;

wire [31:0]Memory_Read_Data_inst1, Memory_Read_Data_inst2,writeData_inst1 ;
wire [4:0] dest_reg_inst1_Mem, dest_reg_inst2_Mem, dest_reg_inst1_WB, dest_reg_inst2_WB;
wire [31:0]writeData_inst2_Mem , writeData_inst1_Mem;
wire RegWriteEn_inst1_WB, RegWriteEn_inst2_WB; 
reg stall_inner, NEWRegWriteEn_inst1;

reg [7:0] pcF_inst1,pcF_inst2,pcPlus2_F_pipe,pcBranchF_pipe,pcBranchF_inst2_pipe;
reg BR_J;
	
wire [4:0] WriteRegD1;

reg predictionF_1_pipe,predictionF_2_pipe;

reg wrongPrediction_1 , wrongPrediction_2, flush_F_1, flush_F_2, flush_D_1, flush_D_2, flush_E_2, stallFinal, switchy;

reg [7:0] pcPlus1F,pcPlus2F, pcBranchF, pcBranchF_inst2,next_addr, pcF_inst1_pipe, pcF_inst2_pipe;
reg RAW_R; 

wire xnorOut_1, actual_outcome_inst1, xnorOut_2 , actual_outcome_inst2, branchF1, branchF2;

wire [7:0]pcM_inst2, pcM; 

/*************************** FETCH STAGE *********************************/


IF_ID1_Pipe FETCH_DECODE1_PIPE (.clk(clk), .reset(reset), .inst1_Fetch(selected_inst1_Fetch), .inst2_Fetch(selected_inst2_Fetch), 
.pcF(pcF_inst1_pipe), 
.pcPlus1F(pcF_inst2_pipe), .pcBranchF(pcBranchF_pipe), 
.pcBranchF_inst2(pcBranchF_inst2_pipe),
.pcPlus2_F(pcPlus2_F_pipe), .stall_outer(stallFinal), .flush_F_1(flush_F_1), .flush_F_2(flush_F_2), .predictionF_1(predictionF_1_pipe), .predictionF_2(predictionF_2_pipe), .pcPlus2_D(pcPlus2_D), 
.inst1_Decode(inst1_Decode), .inst2_Decode(inst2_Decode), .pcD(pcD), .pcD_inst2(pcD_inst2), .pcBranchD(pcBranchD_inst1), .pcBranchD_inst2(pcBranchD_inst2), 
.predictionD_1(predictionD_1),.predictionD_2(predictionD_2));



 BPU  bpu (
     .clk(clk),
     .reset(reset),
     .PC_inst1_F(pcF_inst1),
	   .PC_inst1_E(pc_EX),
	  .actual_outcome_inst1(actual_outcome_inst1),       
     .Branch_inst1(Branch_inst1_EX),
     .PC_inst2_F(pcF_inst2),    
	  .PC_inst2_E(pcE_inst2),
     .actual_outcome_inst2(actual_outcome_inst2),       
     .Branch_inst2(Branch_inst2_EX),
    
	  .prediction_inst1(predictionF_1),
	  .prediction_inst2(predictionF_2)         
);



InstructionMemory IM (.address_a(next_addr), .address_b(next_addr + 8'd1), .clock(clk), .rden_a(~stallFinal), .rden_b(~stallFinal) ,.q_a(inst1_Fetch), .q_b(inst2_Fetch));


mini_Control_Unit mcu1( .OPCODE (inst1_Fetch[31:26]), .branchF(branchF1));
  
  
mini_Control_Unit mcu2( .OPCODE (inst2_Fetch[31:26]), .branchF(branchF2));


always@(posedge clk, negedge reset) 
    begin
    if (~reset)
        PC <= 8'b11111110; 
    else
        PC <= next_addr;
    end
	 
always @(*) begin
	
	 pcF_inst1 = PC; 
    pcF_inst2 = pcF_inst1 + 8'd1;
	 pcPlus1F = PC + 8'd1;
    pcPlus2F = PC + 8'd2;
    pcBranchF = pcPlus1F + inst1_Fetch[7:0];
    pcBranchF_inst2 = pcPlus2F + inst2_Fetch[7:0];
end


always @(*)
	begin
		wrongPrediction_1 = 1'b0;
		wrongPrediction_2 = 1'b0;
		
		wrongPrediction_1 = ((prediction_EX_1!=actual_outcome_inst1) && Branch_inst1_EX);
		wrongPrediction_2 = ((prediction_EX_2!=actual_outcome_inst2) && Branch_inst2_EX);
		
	
	
	end 

	
	Mux3to1 #(5) writeReg1D (.in1(Rt_D_inst1), .in2(Rd_D_inst1),.in3(5'd31), .s(RegDst_inst1_D), .out(WriteRegD1)); //pick either rt/rd 

//Mux3to1 #(5) writeReg2D (.in1(Rt_D_inst2), .in2(Rd_D_inst2),.in3(5'd31), .s(RegDst_inst2_D), .out(WriteRegD2)); //pick either rt/rd 
	

always @(*)
	begin
		stall_inner = 1'b0;
		
		RAW_R = 1'b0;
		
		BR_J = 1'b0;
		//I-TYPE -> dest = Rt / source = Rs
		//check for RAW
				RAW_R = (RegWriteEn_inst1_D &&  (WriteRegD1 != 0) &&  (~JUMP_inst2_D) && ((WriteRegD1 == Rs_D_inst2) || (~ALUSrc_inst2_D) && (WriteRegD1 == Rt_D_inst2)));
				
				BR_J = PCsrc_inst2_D && Branch_inst1_D;
				
				stall_inner = RAW_R || BR_J ; 
				
				
	end 



/*
flush_F_1
flush_F_2
flush_D_1
flush_D_2
flush_E_2
*/

always@(*) begin 

		switchy = 1'b0;
		stallFinal = 1'b0;
		flush_F_1 = 1'b0;
		flush_F_2 = 1'b0;
		flush_D_1 = 1'b0;
		flush_D_2 = 1'b0;
		flush_E_2 = 1'b0;
		
		
// missprediction

	if( wrongPrediction_1)
	begin
		flush_F_1 = 1'b1;
		flush_F_2 = 1'b1;
		flush_D_1 = 1'b1;
		flush_D_2 = 1'b1;
		flush_E_2 = 1'b1;
		
		next_addr = actual_outcome_inst1 ? pcBranch_EX_inst1 : pc_EX + 8'd1;
	end
	
	else if (wrongPrediction_2)
	begin
		flush_F_1 = 1'b1;
		flush_F_2 = 1'b1;
		flush_D_1 = 1'b1;
		flush_D_2 = 1'b1;
		
		next_addr = actual_outcome_inst2 ? pcBranch_EX_inst2 : pcE_inst2 + 8'd1;
	end
	
	else if (outer_depend)
	begin
		flush_D_1 = 1'b1;
		flush_D_2 = 1'b1;
		next_addr = PC; 
		stallFinal = 1'b1;
	end	 
	 
	 
	 
	else if (PCsrc_inst1_D)
	begin
	
	
		if (JUMP_inst1_D)	//J / JAL
		begin
			flush_F_1 = 1'b1;
			flush_F_2 = 1'b1;
			flush_D_2 = 1'b1;
			
			next_addr = extendedImmediate_inst1[7:0];
		end
		
		else //JR
		begin
			flush_F_1 = 1'b1;
			flush_F_2 = 1'b1;
			flush_D_2 = 1'b1;
			next_addr = readData1_inst1[7:0];
		end 
	end
	
	
	//jump or jr w not branch in upper lane 
	else if (PCsrc_inst2_D && ~Branch_inst1_D)
	begin
	
		if(JUMP_inst2_D)
		begin
		flush_F_1 = 1'b1;
		flush_F_2 = 1'b1;
		
		next_addr = extendedImmediate_inst2[7:0];
		end
		
		else
		begin
		flush_F_1 = 1'b1;
		flush_F_2 = 1'b1;
		
		next_addr =  readData1_inst2[7:0];
		end
		
	end 

	else if (stall_inner)
	begin
		switchy = 1'b1;
		flush_D_2 = 1'b1;
		
		if(predictionF_1 && branchF1)
		begin
			next_addr = pcBranchF; 
		end
		
		else
		begin
			next_addr = PC + 8'd1;
		end
		
		end
	
	else if (predictionF_1 && branchF1)
	begin
		flush_F_2 = 1'b1;
		next_addr = pcBranchF;
	end
	
	else if (predictionF_2 && branchF2)
	begin
		next_addr = pcBranchF_inst2;
	end
	
	else
	begin
		next_addr = PC + 8'd2;
	end	

end


always @(*)
begin
if (switchy)
    begin
		  
        selected_inst1_Fetch = inst2_Decode ;
        selected_inst2_Fetch= inst1_Fetch;
        pcF_inst1_pipe = pcD_inst2;
        pcF_inst2_pipe = pcF_inst1;
        pcPlus2_F_pipe= pcF_inst2 + 8'b1;
        pcBranchF_pipe= pcBranchD_inst2 ;
        pcBranchF_inst2_pipe= pcBranchF;
        predictionF_1_pipe=predictionD_2;
        predictionF_2_pipe=predictionF_1;
    end
else
    begin
        selected_inst1_Fetch =  inst1_Fetch;
        selected_inst2_Fetch= inst2_Fetch;
        pcF_inst1_pipe = pcF_inst1; 
        pcF_inst2_pipe = pcF_inst2;
        pcPlus2_F_pipe = pcPlus2F;
        pcBranchF_pipe = pcBranchF ;
        pcBranchF_inst2_pipe = pcBranchF_inst2;
        predictionF_1_pipe = predictionF_1;
        predictionF_2_pipe = predictionF_2;
    end
end
     //mux2to1 #(32) instruction1_switchy  (.in1(inst1_Fetch), .in2(inst2_Decode), .s(stall_inner), .out(selected_inst1_Fetch));

     //mux2to1 #(32) instruction2_switchy  (.in1(inst2_Fetch), .in2(inst1_Fetch), .s(stall_inner), .out(selected_inst2_Fetch));

/****************************DECODE STAGE**************************************/

    assign Rs_D_inst1 = inst1_Decode[25:21];
    assign Rt_D_inst1 = inst1_Decode[20:16];  
    assign Rd_D_inst1 = inst1_Decode[15:11];  
    assign bit26_D_inst1= inst1_Decode[26];
            
    assign Rs_D_inst2 = inst2_Decode[25:21];
    assign Rt_D_inst2 = inst2_Decode[20:16];  
    assign Rd_D_inst2 = inst2_Decode[15:11];
	 assign bit26_D_inst2= inst2_Decode[26];
            	 

    assign immediate_inst1 = inst1_Decode[15:0];
    assign immediate_inst2 = inst2_Decode[15:0];

    assign shamt_inst1 = inst1_Decode[10:6];
    assign shamt_inst2 = inst2_Decode[10:6];

SignExtend inst1_imm (.immediate(immediate_inst1), .signExtend(sign_ext_inst1_D), .extendedImmediate(extendedImmediate_inst1));

SignExtend inst2_imm (.immediate(immediate_inst2), .signExtend(sign_ext_inst2_D), .extendedImmediate(extendedImmediate_inst2));

//---------------------------------control units --------------------------------------------------------------
ControlUnit CU_inst1 (.opcode(opcode_inst1), .funct(funct_inst1), .RegDst(RegDst_inst1_D), .Branch(Branch_inst1_D), .MemReadEn(MemReadEn_inst1_D), 
.MemtoReg(MemtoReg_inst1_D), .ALUOp(ALUOp_inst1_D), .MemWriteEn(MemWriteEn_inst1_D), .RegWriteEn(RegWriteEn_inst1_D), .ALUSrc(ALUSrc_inst1_D),
.JUMP(JUMP_inst1_D),.sign_ext(sign_ext_inst1_D), .PCsrc(PCsrc_inst1_D));


ControlUnit CU_inst2 (.opcode(opcode_inst2), .funct(funct_inst2), .RegDst(RegDst_inst2_D), .Branch(Branch_inst2_D), .MemReadEn(MemReadEn_inst2_D),
.MemtoReg(MemtoReg_inst2_D), .ALUOp(ALUOp_inst2_D), .MemWriteEn(MemWriteEn_inst2_D), .RegWriteEn(RegWriteEn_inst2_D), .ALUSrc(ALUSrc_inst2_D),
.JUMP(JUMP_inst2_D),.sign_ext(sign_ext_inst2_D), .PCsrc(PCsrc_inst2_D));


            
//------------------------------------RF---------------------------------------------------------------------------



RegFile RF (.clk(clk), .rst(reset), .WriteEnable_inst1(RegWriteEn_inst1_WB), .WriteEnable_inst2(RegWriteEn_inst2_WB),
    .readRegister1_inst1(Rs_D_inst1), .readRegister2_inst1(Rt_D_inst1), .writeRegister_inst1(dest_reg_inst1_WB),  //mux bcz rd or rt or 31
    .writeData_inst1(writeData_inst1), .readData1_inst1(readData1_inst1), .readData2_inst1(readData2_inst1),  

    .readRegister1_inst2(Rs_D_inst2), .readRegister2_inst2(Rt_D_inst2), .writeRegister_inst2(dest_reg_inst2_WB),  
    .writeData_inst2(writeData_inst2), .readData1_inst2(readData1_inst2), .readData2_inst2(readData2_inst2));


//-----------------------------------load use check between packets ---------------------------------
//check for load-use hazard -> outer_depend is basically a stall in the decode until load instruction finishes. 

    
        
		  assign dep_upper_upper = (MemReadEn_inst1_EX && (~PCsrc_inst1_D) && ((dest_reg_inst1_EX == Rs_D_inst1) || ((~ALUSrc_inst1_D) && (dest_reg_inst1_EX == Rt_D_inst1))) && (dest_reg_inst1_EX != 5'b0));
        assign dep_upper_lower = (MemReadEn_inst1_EX && (~PCsrc_inst2_D) && ((dest_reg_inst1_EX == Rs_D_inst2) || ((~ALUSrc_inst2_D) && (dest_reg_inst1_EX == Rt_D_inst2))) && (dest_reg_inst1_EX != 5'b0));
        assign dep_lower_upper = (MemReadEn_inst2_EX && (~PCsrc_inst1_D) && ((dest_reg_inst2_EX == Rs_D_inst1) || ((~ALUSrc_inst1_D) && (dest_reg_inst2_EX == Rt_D_inst1))) && (dest_reg_inst2_EX != 5'b0));
        assign dep_lower_lower = (MemReadEn_inst2_EX && (~PCsrc_inst2_D) && ((dest_reg_inst2_EX == Rs_D_inst2) || ((~ALUSrc_inst2_D) && (dest_reg_inst2_EX == Rt_D_inst2))) && (dest_reg_inst2_EX != 5'b0));
    
        assign outer_depend =  dep_upper_upper || dep_upper_lower || dep_lower_upper || dep_lower_lower ; //stall 
        
// --------------------------------------------------------------------------------------------------------------




/************************EXECUTE STAGE**************************************/
/*In the execute stage, we are allowing for any type of instruction to be with another 
within the same packet except branch, only 1 branch within a packet is allowed*/

//D-EX 1ST INST PIPE


ID_EX_inst1Pipe ID_EX_INST1_PIPE (.clk(clk), .reset(reset), .Rd_D_inst1(Rd_D_inst1), .Rs_D_inst1(Rs_D_inst1), .Rt_D_inst1(Rt_D_inst1),  
    .readData1_D_inst1(readData1_inst1), .readData2_D_inst1(readData2_inst1), .Imm_D_inst1(extendedImmediate_inst1),  
    .pcBranchD(pcBranchD_inst1), .pcD(pcD), .predictionD(predictionD_1),  
    .shamt_inst1(shamt_inst1), .bit26_D_inst1(bit26_D_inst1),
     .flush_D_1(flush_D_1), .pcPlus2_D(pcPlus2_D),
    .MemReadEn_inst1_D(MemReadEn_inst1_D), .MemWriteEn_inst1_D(MemWriteEn_inst1_D), .RegWriteEn_inst1_D(RegWriteEn_inst1_D),  
    .ALUSrc_inst1_D(ALUSrc_inst1_D),  .Branch_inst1_D(Branch_inst1_D),
    .MemtoReg_inst1_D(MemtoReg_inst1_D), .RegDst_inst1_D(RegDst_inst1_D), .ALUOp_inst1_D(ALUOp_inst1_D),  

    .Rd_EX_inst1(Rd_EX_inst1), .Rs_EX_inst1(Rs_EX_inst1), .Rt_EX_inst1(Rt_EX_inst1), .readData1_EX_inst1(readData1_EX_inst1),  
    .readData2_EX_inst1(readData2_EX_inst1), .Imm_EX_inst1(Imm_EX_inst1), .pc_EX(pc_EX),
    .pcBranch_EX(pcBranch_EX_inst1), .prediction_EX(prediction_EX_1),  
    .shamt_inst1_EX(shamt_inst1_EX), .bit26_E_inst1(bit26_E_inst1),
    .MemReadEn_inst1_EX(MemReadEn_inst1_EX), .MemWriteEn_inst1_EX(MemWriteEn_inst1_EX), .RegWriteEn_inst1_EX(RegWriteEn_inst1_EX),  
    .ALUSrc_inst1_EX(ALUSrc_inst1_EX),.Branch_inst1_EX(Branch_inst1_EX),.pcPlus2_EX(pcPlus2_EX),
    .MemtoReg_inst1_EX(MemtoReg_inst1_EX), .RegDst_inst1_EX(RegDst_inst1_EX), .ALUOp_inst1_EX(ALUOp_inst1_EX));

//D-EX 2ND INST PIPE 
ID_EX_inst2Pipe ID_EX_INST2_PIPE (.clk(clk), .reset(reset), .Rd_D_inst2(Rd_D_inst2), .Rs_D_inst2(Rs_D_inst2), .Rt_D_inst2(Rt_D_inst2),  
    .readData1_D_inst2(readData1_inst2), .readData2_D_inst2(readData2_inst2), .Imm_D_inst2(extendedImmediate_inst2),  
    .pcBranchD(pcBranchD_inst2), .predictionD_2(predictionD_2),  .pcD_inst2(pcD_inst2), 
    .shamt_inst2(shamt_inst2), .bit26_D_inst2(bit26_D_inst2),  .pcE_inst2(pcE_inst2),  
    .flush_D_2(flush_D_2),
    .MemReadEn_inst2_D(MemReadEn_inst2_D), .MemWriteEn_inst2_D(MemWriteEn_inst2_D), .RegWriteEn_inst2_D(RegWriteEn_inst2_D),  
    .ALUSrc_inst2_D(ALUSrc_inst2_D),  .Branch_inst2_D(Branch_inst2_D),   
    .MemtoReg_inst2_D(MemtoReg_inst2_D), .RegDst_inst2_D(RegDst_inst2_D), .ALUOp_inst2_D(ALUOp_inst2_D),  
    .shamt_inst2_EX(shamt_inst2_EX), .bit26_E_inst2 (bit26_E_inst2),
    .Rd_EX_inst2(Rd_EX_inst2), .Rs_EX_inst2(Rs_EX_inst2), .Rt_EX_inst2(Rt_EX_inst2), .readData1_EX_inst2(readData1_EX_inst2),  
    .readData2_EX_inst2(readData2_EX_inst2), .Imm_EX_inst2(Imm_EX_inst2), .pcBranch_EX(pcBranch_EX_inst2),  
    .prediction_EX_2(prediction_EX_2),  

    .MemReadEn_inst2_EX(MemReadEn_inst2_EX), .MemWriteEn_inst2_EX(MemWriteEn_inst2_EX), .RegWriteEn_inst2_EX(RegWriteEn_inst2_EX),  
    .ALUSrc_inst2_EX(ALUSrc_inst2_EX),  .Branch_inst2_EX(Branch_inst2_EX),  
    .MemtoReg_inst2_EX(MemtoReg_inst2_EX), .RegDst_inst2_EX(RegDst_inst2_EX), .ALUOp_inst2_EX(ALUOp_inst2_EX));


// FIRST INSTRUCTION LANE 
ALU ALU_1 (.ALUop(ALUOp_inst1_EX), .op1(ALU_inst1_in1), .op2(ALU_INST1_IN2_FINAL), .shamt(shamt_inst1_EX), .result(AluOutExecute_inst1), .OVF(OVF1));


// SECOND INSTRUCTION LANE 
ALU ALU_2 (.ALUop(ALUOp_inst2_EX), .op1(ALU_inst2_in1), .op2(ALU_INST2_IN2_FINAL), .shamt(shamt_inst2_EX), .result(AluOutExecute_inst2 ), .OVF(OVF2));



//BRANCH LANE 
BranchCmpUnit branch_unit_inst1 (.in1(ALU_inst1_in1), .in2(ALU_inst1_in2), .out(equal_inst1));

BranchCmpUnit branch_unit_inst2 (.in1(ALU_inst2_in1), .in2(ALU_inst2_in2), .out(equal_inst2));


XnorGate XnorBranch_1(.in1(~equal_inst1), .in2(bit26_E_inst1), .out(xnorOut_1));

ANDGate branchAnd_1 (.in1(xnorOut_1), .in2(Branch_inst1_EX), .out(actual_outcome_inst1));

XnorGate XnorBranch_2(.in1(~equal_inst2), .in2(bit26_E_inst2), .out(xnorOut_2));

ANDGate branchAnd_2 (.in1(xnorOut_2), .in2(Branch_inst2_EX), .out(actual_outcome_inst2));



//Forwarding unit 
ForwardingUnit FU (.Rd_mem_inst1(dest_reg_inst1_Mem), .Rd_WB_inst1(dest_reg_inst1_WB), .Rs_EX_inst1(Rs_EX_inst1), .Rt_EX_inst1(Rt_EX_inst1),  
    .RegWrite_mem_inst1(RegWriteEn_inst1_Mem), .RegWrite_WB_inst1(RegWriteEn_inst1_WB),  
    .Rd_mem_inst2(dest_reg_inst2_Mem), .Rd_WB_inst2(dest_reg_inst2_WB), .Rs_EX_inst2(Rs_EX_inst2), .Rt_EX_inst2(Rt_EX_inst2),  .RegWrite_mem_inst2(RegWriteEn_inst2_Mem), 
    .RegWrite_WB_inst2(RegWriteEn_inst2_WB), .forwardA_inst1(forwardA_inst1), .forwardB_inst1(forwardB_inst1), .forwardA_inst2(forwardA_inst2), .forwardB_inst2(forwardB_inst2));


	 
//	 localparam FROM_WB_INST1  = 3'b100;  // Forward from Writeback stage, instruction 1
//    localparam FROM_MEM_INST1 = 3'b010;  // Forward from Memory stage, instruction 1
//    localparam FROM_MEM_INST2 = 3'b001;  // Forward from Memory stage, instruction 2
//    localparam FROM_WB_INST2  = 3'b011;  // Forward from Writeback stage, instruction 2
//    localparam NO_FORWARD     = 3'b000;  // No forwarding needed
//
//    // Forwarding logic implementation
//     localparam FROM_WB_INST1  = 3'b100;  // Forward from Writeback stage, instruction 1
//    localparam FROM_MEM_INST1 = 3'b010;  // Forward from Memory stage, instruction 1
//    localparam FROM_MEM_INST2 = 3'b001;  // Forward from Memory stage, instruction 2
//    localparam FROM_WB_INST2  = 3'b011;  // Forward from Writeback stage, instruction 2
//    localparam NO_FORWARD     = 3'b000;  // No forwarding needed
//Forwarding muxes for inst1 
Mux5to1 #(32) Forward_A_inst1  (.in1(readData1_EX_inst1),.in2(AluOutMem_inst2),.in3(AluOutMem_inst1),.in4(writeData_inst2),.in5(writeData_inst1),.s(forwardA_inst1),.out(ALU_inst1_in1));
Mux5to1 #(32) Forward_B_inst1  (.in1(readData2_EX_inst1),.in2(AluOutMem_inst2),.in3(AluOutMem_inst1),.in4(writeData_inst2),.in5(writeData_inst1),.s(forwardB_inst1),.out(ALU_inst1_in2));

//Forwarding muxes for inst2 
Mux5to1 #(32) Forward_A_inst2  (.in1(readData1_EX_inst2),.in2(AluOutMem_inst2),.in3(AluOutMem_inst1),.in4(writeData_inst2),.in5(writeData_inst1),.s(forwardA_inst2),.out(ALU_inst2_in1));//first ALU input 
Mux5to1 #(32) Forward_B_inst2  (.in1(readData2_EX_inst2),.in2(AluOutMem_inst2),.in3(AluOutMem_inst1),.in4(writeData_inst2),.in5(writeData_inst1),.s(forwardB_inst2),.out(ALU_inst2_in2));//the output of this mux is the final ALU mux input with the immediate value


mux2to1 Final_Alu_inst1_B_Src (.in1(ALU_inst1_in2), .in2(Imm_EX_inst1), .s(ALUSrc_inst1_EX), .out(ALU_INST1_IN2_FINAL));
mux2to1 Final_Alu_inst2_B_Src (.in1(ALU_inst2_in2), .in2(Imm_EX_inst2), .s(ALUSrc_inst2_EX), .out(ALU_INST2_IN2_FINAL));



Mux3to1 #(5) regDstEMux_inst1(.in1(Rt_EX_inst1), .in2(Rd_EX_inst1),.in3(5'd31), .s(RegDst_inst1_EX), .out(dest_reg_inst1_EX)); //pick either rt/rd 

Mux3to1 #(5) regDstEMux_inst2(.in1(Rt_EX_inst2), .in2(Rd_EX_inst2),.in3(5'd31), .s(RegDst_inst2_EX), .out(dest_reg_inst2_EX)); //pick either rt/rd 

/************************MEMORY STAGE**************************************/


EX_MEM_inst1Pipe EX_MEM_INST1_PIPE  (.clk(clk), .reset(reset), .AluOutExecute_inst1(AluOutExecute_inst1), .ReadData2Execute_inst1(ALU_inst1_in2),  
    .dest_reg_inst1_EX(dest_reg_inst1_EX), .MemReadEn_inst1_EX(MemReadEn_inst1_EX), .MemWriteEn_inst1_EX(MemWriteEn_inst1_EX),  
    .RegWriteEn_inst1_EX(RegWriteEn_inst1_EX), .MemtoReg_inst1_EX(MemtoReg_inst1_EX), .AluOutMem_inst1(AluOutMem_inst1), .pc_EX(pc_EX),

    .ReadData2Mem_inst1(ReadData2Mem_inst1),.dest_reg_inst1_Mem(dest_reg_inst1_Mem), .pcM(pcM),

    .MemReadEn_inst1_Mem(MemReadEn_inst1_Mem), .MemWriteEn_inst1_Mem(MemWriteEn_inst1_Mem), .RegWriteEn_inst1_Mem(RegWriteEn_inst1_Mem),  
    .MemtoReg_inst1_Mem(MemtoReg_inst1_Mem));



EX_MEM_inst2Pipe EX_MEM_INST2_PIPE (.clk(clk), .reset(reset), .AluOutExecute_inst2(AluOutExecute_inst2), .ReadData2Execute_inst2(ALU_inst2_in2),  
    .dest_reg_inst2_EX(dest_reg_inst2_EX), .pcPlus2_EX(pcPlus2_EX), .flush_E_2(flush_E_2),.pcE_inst2(pcE_inst2),
    .MemReadEn_inst2_EX(MemReadEn_inst2_EX), .MemWriteEn_inst2_EX(MemWriteEn_inst2_EX), .RegWriteEn_inst2_EX(RegWriteEn_inst2_EX),  
    .MemtoReg_inst2_EX(MemtoReg_inst2_EX), .AluOutMem_inst2(AluOutMem_inst2), .pcM_inst2(pcM_inst2),
    .ReadData2Mem_inst2(ReadData2Mem_inst2), .dest_reg_inst2_Mem (dest_reg_inst2_Mem), .pcPlus2_Mem(pcPlus2_Mem), .MemReadEn_inst2_Mem(MemReadEn_inst2_Mem),  
    .MemWriteEn_inst2_Mem(MemWriteEn_inst2_Mem), .RegWriteEn_inst2_Mem(RegWriteEn_inst2_Mem), .MemtoReg_inst2_Mem(MemtoReg_inst2_Mem));



DataMemory DM  (.address_a(AluOutMem_inst1[11:0]), .address_b(AluOutMem_inst2[11:0]), .clock(~clk), .data_a(ReadData2Mem_inst1), .data_b(ReadData2Mem_inst2), 
 .rden_a(MemReadEn_inst1_Mem), .rden_b(MemReadEn_inst2_Mem), .wren_a(MemWriteEn_inst1_Mem), .wren_b(MemWriteEn_inst2_Mem), .q_a(Memory_Read_Data_inst1),
  .q_b(Memory_Read_Data_inst2));
  
  
//DataMemory DM (
//	.address_a(AluOutMem_inst1[10:0]),
//	.address_b(AluOutMem_inst2[10:0]),
//	.clock_a(clk),
//	.clock_b(~clk),
//	.data_a(ReadData2Mem_inst1),
//	.data_b(ReadData2Mem_inst2),
//	.rden_a(MemReadEn_inst1_Mem),
//	.rden_b(MemReadEn_inst2_Mem),
//	.wren_a(MemWriteEn_inst1_Mem),
//	.wren_b(MemWriteEn_inst2_Mem),
//	.q_a(Memory_Read_Data_inst1),
//	.q_b(Memory_Read_Data_inst2));  
  
  always @(*)
  begin
if( (RegWriteEn_inst1_Mem && RegWriteEn_inst2_Mem && (dest_reg_inst1_Mem == dest_reg_inst2_Mem )&& (dest_reg_inst1_Mem != 0) ))
            NEWRegWriteEn_inst1=1'd0;
        else
            NEWRegWriteEn_inst1=RegWriteEn_inst1_Mem;
				
			end 
			
			

Mux3to1 #(32) WRITE_BACK_MUX_INST1  (.in1(AluOutMem_inst1),.in2(Memory_Read_Data_inst1),.in3({24'b0,(pcM + 8'd1)}),.s(MemtoReg_inst1_Mem),.out(writeData_inst1_Mem));

Mux3to1 #(32) WRITE_BACK_MUX_INST2  (.in1(AluOutMem_inst2),.in2(Memory_Read_Data_inst2),.in3({24'b0,(pcM_inst2 + 8'd1)}),.s(MemtoReg_inst2_Mem),.out(writeData_inst2_Mem));

/************************WRITE BACK STAGE**************************************/


MEM_WB_inst1Pipe  MEM_WB_INST1_PIPE (.clk(clk), .reset(reset), .writeData_inst1_Mem(writeData_inst1_Mem),  
    .dest_reg_inst1_Mem(dest_reg_inst1_Mem), .RegWriteEn_inst1_Mem(NEWRegWriteEn_inst1), 
	 .dest_reg_inst1_WB(dest_reg_inst1_WB),.RegWriteEn_inst1_WB(RegWriteEn_inst1_WB), .writeData_inst1_WB(writeData_inst1));


MEM_WB_inst2Pipe  MEM_WB_INST2_PIPE (.clk(clk), .reset(reset), .dest_reg_inst2_Mem(dest_reg_inst2_Mem),. writeData_inst2_Mem(writeData_inst2_Mem),
	.RegWriteEn_inst2_Mem(RegWriteEn_inst2_Mem), 
   .dest_reg_inst2_WB(dest_reg_inst2_WB),.RegWriteEn_inst2_WB(RegWriteEn_inst2_WB), . writeData_inst2_WB(writeData_inst2));





endmodule
