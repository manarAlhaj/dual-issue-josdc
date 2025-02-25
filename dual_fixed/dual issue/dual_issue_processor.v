
//This is a 6 stage dual issue processo 
//2 Decode stages to increase clock speed

module dual_issue_processor (
    input clk,
    input reset,
    output reg [7:0] PC
);


wire [7:0] pcPlus2_D, pcD, pcPlus1D, pcBranchD_inst1, pcBranchD_inst2, pcD, pcPlus1D, pcPlus2_D, pcBranchD_inst1, pcBranchD_inst2;

//all instruction 1 signals 
wire [5:0] opcode_inst1, funct_inst1;
wire [31:0] inst1_Fetch, inst1_Decode ,instruction1Decode, 
wire [31:0] readData1_inst1, readData2_inst1;

assign opcode_inst1 = inst1_Decode[31:26];
assign funct_inst1 = inst1_Decode[5:0];

wire predictionD ,predictionD, ;
wire MemReadEn_inst1_D, MemWriteEn_inst1_D, RegWriteEn_inst1_D, ALUSrc_inst1_D,JUMP_inst1_D, Branch_inst1_D, PCsrc_inst1_D, sign_ext_inst1_D, outer_depend;
wire [1:0] RegDst_inst1_D, MemtoReg_inst1_D;
wire [3:0] ALUOp_inst1_D; 
wire [4:0] Rs_D_inst1, Rt_D_inst1, Rd_D_inst1 ,writeRegister_inst1;

//all instruction 2 signals 
wire [5:0] opcode_inst2, funct_inst2;
wire [31:0] inst2_Fetch, inst2_Decode, instruction2Decode;
wire [31:0] readData1_inst2, readData2_inst2;

assign opcode_inst2 = inst2_Decode[31:26];
assign funct_inst2 = inst2_Decode[5:0];

wire [1:0] RegDst_inst2_D, MemtoReg_inst2_D;
wire [3:0] ALUOp_inst2_D;
wire Branch_inst2_D, MemReadEn_inst2_D, MemWriteEn_inst2_D, RegWriteEn_inst2_D, ALUSrc_inst2_D, JUMP_inst2_D, sign_ext_inst2_D, PCsrc_inst2_D;
wire MemReadEn_inst2_D, MemWriteEn_inst2_D, RegWriteEn_inst2_D, ALUSrc_inst2_D, JUMP_inst2_D, Branch_inst2_D, PCsrc_inst2_D,sign_ext_inst2_D, 
NewJump_inst2, NewpcSource_inst2 ;
wire [1:0 ] MemtoReg_inst2_D, RegDst_inst2_D ;
wire[3:0] ALUOp_inst2_D; 
wire [4:0] Rs_D_inst2, Rt_D_inst2, Rd_D_inst2, writeRegister_inst2;

/***************************WIRES****************************************/
  
wire predictionF_1 ,predictionF_2,predictionF_1_pipe,predictionF_2_pipe;
wire [7:0] pcF_pipe,pcPlus1F_pipe,pcPlus2_F_pipe,pcBranchF_pipe,pcBranchF_inst2_pipe;

wire [31:0] selected_inst1_Fetch, selected_inst2_Fetch; 
wire [4:0] shamt_inst1 , shamt_inst2;
wire[15:0] immediate_inst1, immediate_inst2;
wire [31:0] extendedImmediate_inst1, extendedImmediate_inst2;

wire outer_depend;
wire dep_upper_upper, dep_upper_lower, dep_lower_upper, dep_lower_lower;

wire [4:0] Rd_EX_inst1, Rs_EX_inst1,Rt_EX_inst1, shamt_inst1_EX;
wire [7:0] pc_EX, pcPlus1_EX , pcBranch_EX_inst1; 
wire [31:0] readData1_EX_inst1, readData2_EX_inst1, Imm_EX_inst1; 

wire prediction_EX, MemReadEn_inst1_EX, MemWriteEn_inst1_EX,RegWriteEn_inst1_EX,ALUSrc_inst1_EX,JUMP_inst1_EX, Branch_inst1_EX, PCsrc_inst1_EX;
wire [1:0]MemtoReg_inst1_EX, RegDst_inst1_EX ;
wire [3:0]ALUOp_inst1_EX;

wire [4:0]Rd_EX_inst2, Rs_EX_inst2, Rt_EX_inst2 , shamt_inst2_EX;
wire [7:0] pcBranch_EX_inst2, pcPlus2_EX;
wire [31:0]readData1_EX_inst2, readData2_EX_inst2,Imm_EX_inst2,pcPlus2_EX;
wire prediction_EX,prediction_EX_2,MemReadEn_inst2_EX, MemWriteEn_inst2_EX, RegWriteEn_inst2_EX, ALUSrc_inst2_EX , JUMP_inst2_EX, Branch_inst2_EX, PCsrc_inst2_EX;
wire [1:0]MemtoReg_inst2_EX, RegDst_inst2_EX;
wire [3:0] ALUOp_inst2_EX;

wire RegWrite_mem_inst1,RegWrite_WB_inst1,RegWrite_mem_inst2, RegWrite_WB_inst2;
wire [31:0] ALU_inst1_in1,ALU_inst1_in2,ALU_INST1_IN2_FINAL,ALU_INST2_IN2_FINAL ;

wire OVF1, OVF2;
wire equal_inst1, equal_inst2, xnorOut, bit26_E_inst1, bit26_E_inst2, actual_outcome_inst;

wire [2:0] forwardA_inst1, forwardB_inst1, forwardA_inst2, forwardB_inst2;


wire[4:0]dest_reg_inst1_EX, dest_reg_inst2_EX;

wire [31:0] AluOutExecute_inst1, AluOutExecute_inst2, readData2_EX_inst1, AluOutMem_inst1, ReadData2Mem_inst1, AluOutMem_inst2,ReadData2Mem_inst2;
wire [4:0] dest_reg_inst1_Mem,dest_reg_inst2_Mem;  
wire MemReadEn_inst1_Mem, MemWriteEn_inst1_Mem, RegWriteEn_inst1_Mem, MemReadEn_inst2_Mem, MemWriteEn_inst2_Mem,RegWriteEn_inst2_Mem;
wire [1:0]MemtoReg_inst1_Mem,RegDst_inst1_Mem, MemtoReg_inst2_Mem, RegDst_inst2_Mem;
wire[7:0]pcPlus2_Mem;

wire [31:0]Memory_Read_Data_inst1, Memory_Read_Data_inst2;


wire [4:0] dest_reg_inst1_Mem, dest_reg_inst2_Mem, dest_reg_inst1_WB, dest_reg_inst2_WB;
wire [31:0] MemReadDataWB_inst1, AluResultWB_inst1,MemReadDataWB_inst2, AluResultWB_inst2;
wire [1:0] MemtoRegWB_inst1, MemtoRegWB_inst2;
wire [7:0]pcPlus2_WB;
wire RegWriteEn_inst1_WB, RegWriteEn_inst2_WB; 

/***************************FETCH STAGE *********************************/
reg [7:0] pcPlus1F,pcPlus2F, pcBranchF, pcBranchF_inst2,next_addr;
//todo -> flushes and stalls
IF_ID_Pipe FETCH_DECODE1_PIPE (.clk(clk), .reset(reset), .inst1_Fetch(selected_inst1_Fetch), .inst2_Fetch(selected_inst2_Fetch), .pcF(pcF_pipe), .pcPlus1F(pcPlus1F_pipe), .pcBranchF(pcBranchF_pipe), 
.pcBranchF_inst2(pcBranchF_inst2_pipe),
.pcPlus2_F(pcPlus2_F_pipe), .stall_outer(outer_depend), .flush1_J(flush1_J), .flush2_J(flush2_J), .flush1_JR(flush1_JR), .flush2_JR(flush2_JR), .flush1_B(flush1_B), .flush2_B(flush2_B), .predictionF_1(predictionF_1_pipe), .predictionF_2(predictionF_2_pipe), .pcPlus2_D(pcPlus2_D), 
.inst1_Decode(inst1_Decode), .inst2_Decode(inst2_Decode), .pcD(pcD), .pcPlus1D(pcPlus1D), .pcBranchD(pcBranchD_inst1), .pcBranchD_inst2(pcBranchD_inst2), 
.predictionD_1(predictionD_1),.predictionD_2(predictionD_2));

module gshare_branch_predictor (.clk(clk),.reset(reset), .branch_1(Branch_inst1_EX),.branch_2(Branch_inst2_EX), .pc_fetch(PC), .pc2_fetch(pcPlus1F),.pc_execute(pc_EX),.pc2_execute(pcPlus1_EX),
     .branch_taken_1(actual_outcome_inst),.branch_taken_2(actual_outcome_inst),  .prediction_1(predictionF_1),.prediction_2(predictionF_2));


InstructionMemory IM (.address_a(PC), .address_b(pcPlus1F), .clock(clk), .rden_a(~stall_outer), .rden_b(~stall_outer) ,.q_a(inst1_Fetch), .q_b(inst2_Fetch));


// Adder pcplus1 (.in1(PC), .in2(8'd1), .out(pcPlus1F));

// Adder pcplus1 (.in1(PC), .in2(8'd2), .out(pcPlus2F));

// Adder branchTA_inst1 (.in1(pcPlus1F), .in2(inst1_Fetch[7:0]), .out(pcBranchF));

always@(posedge clk) 
    begin
    if (~reset)
        PC <= 8'b11111110; 
    else
        PC <= next_addr;
    end
// TODO:check if inpt is PC or next_addr 
always @(*) 
    begin
        pcPlus1F = PC + 8'd1;
    end    

always @(*)
    begin
        pcPlus2F =  PC + 8'd2;
    end

always @(*) begin
    pcBranchF = pcPlus1F +inst1_Fetch[7:0];
end    
always @(*) begin
    pcBranchF_inst2 = pcPlus2F +inst2_Fetch[7:0];
end   

always @(*)
    begin
        // pcBranch_EX_inst is the TARGET ADDRESSSSSS
        //miss-prediction 
        if(flush1_B)
            begin
                next_addr = actual_prediction_1 ? pcBranch_EX_inst1 : pcPlus1_EX; 
            end
        else if(flush2_B)
            begin
                next_addr = actual_prediction_2 ? pcBranch_EX_inst2 : pcPlus2_EX; 
            end
        //prediction    
        else if(prediction_1)
            begin
                next_addr = pcBranchF;
            end        
        else if (prediction_2)
            begin
                next_addr = pcBranchF_inst2; 
            end    
        
        else if (flush1_J || flush1_JR )
            begin
                if(opcode_inst1 ==  6'b000010)
                    next_addr = extendedImmediate_inst1[7:0];
                else if(opcode_inst1 ==  6'b000011)
                    next_addr = extendedImmediate_inst1[7:0];
                else if (opcode_inst1 == 6'b001000)
                    next_addr = readData1_inst1[7:0];
            end
        else if (flush2_J || flush2_JR)
            begin
                if(opcode_inst2 ==  6'b000010) //j
                    next_addr = extendedImmediate_inst2[7:0];
                else if(opcode_inst2 ==  6'b000011) //jal
                    next_addr = extendedImmediate_inst2[7:0];
                else if (opcode_inst2 == 6'b001000) //jr
                    next_addr = readData1_inst2[7:0];
            end 
        
        else if (outer_depend)
            next_addr = next_addr; 

        else if (stall_inner)
            next_addr = PC + 8'd1;
        else 
            next_addr = PC + 8'd2;

        next_addr = PC; 

    end

if (stall_inner)
    begin
    pcF_pipe= pcPlus1D ;
    pcPlus1F_pipe= PC;
    pcPlus2_F_pipe= pcPlus1F;
    pcBranchF_pipe= pcPlus1D ;
    pcBranchF_inst2_pipe= PC;
    predictionF_1_pipe=predictionD_2;
    predictionF_2_pipe=predictionF_1;
    end
else
    begin
    pcF_pipe= PC; 
    pcPlus1F_pipe= pcPlus1F;
    pcPlus2_F_pipe= pcPlus2_F;
    pcBranchF_pipe= pcBranchF ;
    pcBranchF_inst2_pipe= pcBranchF_inst2;
    predictionF_1_pipe=predictionF_1;
    predictionF_2_pipe=predictionF_2;
    end

    
     mux2to1 instruction1_switchy #(32) (.in1(inst1_Fetch), .in2(inst2_Decode), .s(stall_inner), .out(selected_inst1_Fetch));

     mux2to1 instruction2_switchy #(32) (.in1(inst2_Fetch), .in2(inst1_Fetch), .s(stall_inner), .out(selected_inst2_Fetch));

/****************************DECODE STAGE**************************************/

    assign Rs_D_inst1 = inst1_Decode[25:21];
    assign Rt_D_inst1 = inst1_Decode[20:16];  
    assign Rd_D_inst1 = inst1_Decode[15:11];  
            
            
    assign Rs_D_inst2 = inst2_Decode[25:21];
    assign Rt_D_inst2 = inst2_Decode[20:16];  
    assign Rd_D_inst2 = inst2_Decode[15:11];  

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


//---------------------------------- Hazard detection unit ------------------------------------------------
reg flush1_B,flush2_B, flush1_J, flush2_J, flush1_JR, flush2_JR, wrongPrediction_1, wrongPrediction_2;

	always @(*)
	begin
	  flush1_B = 0;
	  flush2_B = 0;
	  flush1_J = 0;
	  flush2_J = 0;
	  flush1_JR = 0;
	  flush2_JR = 0;
	//flushes
		 // Branch caused flush
					wrongPrediction_1 = ((prediction_1!=actual_prediction_1)& BranchExecute_1);
						 flush1_B=wrongPrediction_1;
					wrongPrediction_2 = ((prediction_2!=actual_prediction_2)& BranchExecute_2);
						 flush2_B=wrongPrediction_2;


    // jump alone caused flush
        // if jump inst occurs ---> flush 
        // if in future that changes , just modify this condition
            flush1_J= PcSource_inst1 && Jump_D1_inst1; 
            flush2_J= PcSource_inst2 && Jump_D1_inst2;
    //jump register caused flush 
            flush1_JR= PcSource_inst1 && ~Jump_D2_inst1; 
            flush2_JR= PcSource_inst2 && ~Jump_D2_inst2;     
//stalls
 // stalls for pipe d1/d2 and pipe if/d1 are direct inpus from outputsof inner and outer dep checks    
    end
//-------------------------------Inner dependency check----------------------------------------------------------



reg stall_inner, flush_inst2_B, NEWRegWriteEn_inst1;

always @(*) begin
    stall_inner = 1'd0;
    flush_inst2_B= 1'd0;
    
  
    //check data hazards
    //check for RAW
        if( RegWriteEn_inst1_D && ((Rd_D_inst1 == Rs_D_inst2 )&& (Rd_D_inst1 != 0) )||((Rd_D_inst1 == Rt_D_inst2 )&& (Rd_D_inst1 != 0)))
            stall_inner = 1'd1;
    // //check for WAR
    //     if( RegWriteEn_inst2_D && ((Rd_D_inst2 == Rs_D_inst1 )&& (Rd_D_inst2 != 0) )||((Rd_D_inst2 == Rt_D_inst1 )&& (Rd_D_inst2 != 0)))
    //         stall_inner = 1'd1;
    
    // //if branch is inst 1 and prediction is taken then flush 2nd ist
         if ((opcode_inst1== 6'b000100 && (actual_outcome_inst == prediction_EX)) || (opcode_inst1== 6'b000101 && (actual_outcome_inst== prediction_EX)))
             flush_inst2_B= 1'd1;
    // if branch is inst 1 and inst 2 is also a branch then flush 2nd branch 
        if ((opcode_inst1== 6'b000100 && (opcode_inst2== 6'b000100 || opcode_inst2== 6'b000101)) || 
            (opcode_inst1== 6'b000101 && (opcode_inst2== 6'b000100 || opcode_inst2== 6'b000101) ))
            flush_inst2_B= 1'd1;
       
end

            
//------------------------------------RF---------------------------------------------------------------------------
RegFile RF (.clk(clk), .rst(reset), .WriteEnable_inst1(NEWRegWriteEn_inst1), .WriteEnable_inst2(RegWriteEn_inst2_D),  
    .readRegister1_inst1(Rs_D_inst1), .readRegister2_inst1(Rt_D_inst1), .writeRegister_inst1(writeRegister_inst1),  //mux bcz rd or rt or 31
    .writeData_inst1(writeData_inst1), .readData1_inst1(readData1_inst1), .readData2_inst1(readData2_inst1),  

    .readRegister1_inst2(Rs_D_inst2), .readRegister2_inst2(Rt_D_inst2), .writeRegister_inst2(writeRegister_inst2),  
    .writeData_inst2(writeData_inst2), .readData1_inst2(readData1_inst2), .readData2_inst2(readData2_inst2));


//-----------------------------------load use check between packets ---------------------------------
//check for load-use hazard -> outer_depend is basically a stall in the decode until load instruction finishes. 
    
    
    
        
        assign dep_upper_upper = (MemReadEn_inst1_EX & ((Rd_EX_inst1 == Rs_D_inst1)
        || (Rd_EX_inst1 == Rt_D_inst1)) & (Rd_EX_inst1 != 5'b0));
    
        assign dep_upper_lower = (MemReadEn_inst1_EX & ((Rd_EX_inst1 == Rs_D_inst2)
        || (Rd_EX_inst1 == Rt_D_inst2)) & (Rd_EX_inst1 != 5'b0));
    
        assign dep_lower_upper = (MemReadEn_inst2_EX & ((Rd_EX_inst2 == Rs_D_inst1)
        || (Rd_EX_inst2 == Rt_D_inst1)) & (Rd_EX_inst2 != 5'b0));
    
        assign dep_lower_lower = (MemReadEn_inst2_EX & ((Rd_EX_inst2 == Rs_D_inst2)
        || (Rd_EX_inst2 == Rt_D_inst2)) & (Rd_EX_inst2 != 5'b0)); 
    
        assign outer_depend =  dep_upper_upper | dep_upper_lower | dep_lower_upper | dep_lower_lower ; //stall 
        
// --------------------------------------------------------------------------------------------------------------




/************************EXECUTE STAGE**************************************/
/*In the execute stage, we are allowing for any type of instruction to be with another 
within the same packet except branch, only 1 branch within a packet is allowed*/

//D-EX 1ST INST PIPE




ID_EX_inst1Pipe ID_EX_INST1_PIPE (.clk(clk), .reset(reset), .Rd_D_inst1(Rd_D_inst1), .Rs_D_inst1(Rs_D_inst1), .Rt_D_inst1(Rt_D_inst1),  
    .readData1_D_inst1(readData1_inst1), .readData2_D_inst1(readData2_inst1), .Imm_D_inst1(extendedImmediate_inst1),  
    .pcBranchD(pcBranchD_inst1), .pcPlus1D(pcPlus1D), .pcD(pcD), .predictionD(predictionD),  
    .shamt_inst1(shamt_inst1),
    .flush1_B(flush1_B), .flush2_B(flush2_B), .flush_inst2_B(flush_inst2_B), 
    .MemReadEn_inst1_D(MemReadEn_inst1_D), .MemWriteEn_inst1_D(MemWriteEn_inst1_D), .RegWriteEn_inst1_D(RegWriteEn_inst1),  
    .ALUSrc_inst1_D(ALUSrc_inst1_D), .JUMP_inst1_D(JUMP_inst1_D), .Branch_inst1_D(Branch_inst1_D), .PCsrc_inst1_D(PCsrc_inst1_D),  
    .MemtoReg_inst1_D(MemtoReg_inst1_D), .RegDst_inst1_D(RegDst_inst1_D), .ALUOp_inst1_D(ALUOp_inst1_D),  

    .Rd_EX_inst1(Rd_EX_inst1), .Rs_EX_inst1(Rs_EX_inst1), .Rt_EX_inst1(Rt_EX_inst1), .readData1_EX_inst1(readData1_EX_inst1),  
    .readData2_EX_inst1(readData2_EX_inst1), .Imm_EX_inst1(Imm_EX_inst1), .pc_EX(pc_EX), .pcPlus1_EX(pcPlus1_EX),  
    .pcBranch_EX(pcBranch_EX_inst1), .prediction_EX(prediction_EX_1),  
    .shamt_inst2_EX(shamt_inst1_EX),
    .MemReadEn_inst1_EX(MemReadEn_inst1_EX), .MemWriteEn_inst1_EX(MemWriteEn_inst1_EX), .RegWriteEn_inst1_EX(RegWriteEn_inst1_EX),  
    .ALUSrc_inst1_EX(ALUSrc_inst1_EX), .JUMP_inst1_EX(JUMP_inst1_EX), .Branch_inst1_EX(Branch_inst1_EX), .PCsrc_inst1_EX(PCsrc_inst1_EX),  
    .MemtoReg_inst1_EX(MemtoReg_inst1_EX), .RegDst_inst1_EX(RegDst_inst1_EX), .ALUOp_inst1_EX(ALUOp_inst1_EX));


//D-EX 2ND INST PIPE 
ID_EX_inst2Pipe ID_EX_INST2_PIPE (.clk(clk), .reset(reset), .Rd_D_inst2(Rd_D_inst2), .Rs_D_inst2(Rs_D_inst2), .Rt_D_inst2(Rt_D_inst2),  
    .readData1_D_inst2(readData1_inst2), .readData2_D_inst2(readData2_inst2), .Imm_D_inst2(extendedImmediate_inst2),  
    .pcBranchD(pcBranchD_inst2), .pcPlus2_D(pcPlus2_D), .predictionD_2(predictionD),  
    .shamt_inst2(shamt_inst2),
    .flush1_B(flush1_B), .flush2_B(flush2_B),  .flush1_JR(flush1_JR), .flush1_J(flush1_J) ,
    .MemReadEn_inst2_D(MemReadEn_inst2_D), .MemWriteEn_inst2_D(MemWriteEn_inst2_D), .RegWriteEn_inst2_D(RegWriteEn_inst2_D),  
    .ALUSrc_inst2_D(ALUSrc_inst2_D), .JUMP_inst2_D(JUMP_inst2_D), .Branch_inst2_D(Branch_inst2_D), .PCsrc_inst2_D(PCsrc_inst2_D),  
    .MemtoReg_inst2_D(MemtoReg_inst2_D), .RegDst_inst2_D(RegDst_inst2_D), .ALUOp_inst2_D(ALUOp_inst2_D),  
    .shamt_inst2_EX(shamt_inst2_EX),
    .Rd_EX_inst2(Rd_EX_inst2), .Rs_EX_inst2(Rs_EX_inst2), .Rt_EX_inst2(Rt_EX_inst2), .readData1_EX_inst2(readData1_EX_inst2),  
    .readData2_EX_inst2(readData2_EX_inst2), .Imm_EX_inst2(Imm_EX_inst2), .pcPlus2_EX(pcPlus2_EX), .pcBranch_EX(pcBranch_EX_inst2),  
    .prediction_EX_2(prediction_EX_2),  

    .MemReadEn_inst2_EX(MemReadEn_inst2_EX), .MemWriteEn_inst2_EX(MemWriteEn_inst2_EX), .RegWriteEn_inst2_EX(RegWriteEn_inst2_EX),  
    .ALUSrc_inst2_EX(ALUSrc_inst2_EX), .JUMP_inst2_EX(JUMP_inst2_EX), .Branch_inst2_EX(Branch_inst2_EX), .PCsrc_inst2_EX(PCsrc_inst2_EX),  
    .MemtoReg_inst2_EX(MemtoReg_inst2_EX), .RegDst_inst2_EX(RegDst_inst2_EX), .ALUOp_inst2_EX(ALUOp_inst2_EX));


   
// FIRST INSTRUCTION LANE 
ALU ALU_1 (.ALUop(ALUOp_inst1_EX), .op1(ALU_inst1_in1), .op2(ALU_INST1_IN2_FINAL), .shamt(shamt_inst1_EX), .result(AluOutExecute_inst1), .OVF(OVF1));


// SECOND INSTRUCTION LANE 
ALU ALU_2 (.ALUop(ALUOp_inst2_EX), .op1(ALU_inst2_in1), .op2(ALU_INST2_IN2_FINAL), .shamt(shamt_inst2_EX), .result(AluOutExecute_inst2 ), .OVF(OVF2));


//BRANCH LANE 
BranchCmpUnit branch_unit_inst1 (.in1(ALU_inst1_in1), .in2(ALU_inst1_in2), .out(equal_inst1));

BranchCmpUnit branch_unit_inst2 (.in1(ALU_inst2_in1), .in2(ALU_inst2_in2), .out(equal_inst2));

mux2to1 final_branch_mux (.in1(equal_inst1), .in2(equal_inst2), .s(Branch_inst2_EX), .out(branch_equal_final)); 

mux2to1 final_bit26_mux (.in1(bit26_E_inst1), .in2(bit26_E_inst2), .s(Branch_inst2_EX), .out(bit_26_final)); 

mux2to1 final_branch_signal (.in1(Branch_inst1_EX), .in2(Branch_inst2_EX), .s(Branch_inst2_EX), .out(final_branch_signal));

XnorGate XnorBranch_1(.in1(~branch_equal_final), .in2(bit_26_final), .out(xnorOut));

ANDGate branchAnd_1 (.in1(xnorOut), .in2(final_branch_signal), .out(actual_outcome_inst));



// wie [4:0] Rd_mem_inst1, Rd_WB_inst1, Rd_mem_inst2, Rd_WB_inst2;

//Forwarding unit 
ForwardingUnit FU (.Rd_mem_inst1(dest_reg_inst1_Mem), .Rd_WB_inst1(dest_reg_inst1_WB), .Rs_EX_inst1(Rs_EX_inst1), .Rt_EX_inst1(Rt_EX_inst1),  
    .RegWrite_mem_inst1(RegWrite_mem_inst1), .RegWrite_WB_inst1(RegWrite_WB_inst1),  
    .Rd_mem_inst2(dest_reg_inst2_Mem), .Rd_WB_inst2(dest_reg_inst2_WB), .Rs_EX_inst2(Rs_EX_inst2), .Rt_EX_inst2(Rt_EX_inst2),  .RegWrite_mem_inst2(RegWrite_mem_inst2), 
    .RegWrite_WB_inst2(RegWrite_WB_inst2), .forwardA_inst1(forwardA_inst1), .forwardB_inst1(forwardB_inst1), .forwardA_inst2(forwardA_inst2), .forwardB_inst2(forwardB_inst2));


//Forwarding muxes for inst1 
Mux5to1 Forward_A_inst1 #(32) (.in1(readData1_EX_inst1),.in2(AluOutMem_inst1),.in3(AluOutMem_inst2),.in4(writeData_inst1),.in5(writeData_inst2),.s(forwardA_inst1),.out(ALU_inst1_in1));
Mux5to1 Forward_B_inst1 #(32) (.in1(readData2_EX_inst1),.in2(AluOutMem_inst1),.in3(AluOutMem_inst2),.in4(writeData_inst1),.in5(writeData_inst2),.s(forwardB_inst1),.out(ALU_inst1_in2));

//Forwarding muxes for inst2 
Mux5to1 Forward_A_inst2 #(32) (.in1(readData1_EX_inst2),.in2(AluOutMem_inst1),.in3(AluOutMem_inst2),.in4(writeData_inst1),.in5(writeData_inst2),.s(forwardA_inst2),.out(ALU_inst2_in1));//first ALU input 
Mux5to1 Forward_B_inst2 #(32) (.in1(readData2_EX_inst2),.in2(AluOutMem_inst1),.in3(AluOutMem_inst2),.in4(writeData_inst1),.in5(writeData_inst2),.s(forwardB_inst2),.out(ALU_inst2_in2));//the output of this mux is the final ALU mux input with the immediate value


mux2to1 Final_Alu_inst1_B_Src (.in1(ALU_inst1_in2), .in2(Imm_EX_inst1), .s(ALUSrc_inst1_EX), .out(ALU_INST1_IN2_FINAL));
mux2to1 Final_Alu_inst2_B_Src (.in1(ALU_inst2_in2), .in2(Imm_EX_inst2), .s(ALUSrc_inst2_EX), .out(ALU_INST2_IN2_FINAL));



Mux3to1 #(5) regDstEMux_inst1(.in1(Rt_EX_inst1), .in2(Rd_EX_inst1),.in3(5'd31), .s(RegDst_inst1_EX), .out(dest_reg_inst1_EX)); //pick either rt/rd 

Mux3to1 #(5) regDstEMux_inst2(.in1(Rt_EX_inst2), .in2(Rd_EX_inst2),.in3(5'd31), .s(RegDst_inst2_EX), .out(dest_reg_inst2_EX)); //pick either rt/rd 

/************************MEMORY STAGE**************************************/

EX_MEM_inst1Pipe EX_MEM_INST1_PIPE  (.clk(clk), .reset(reset), .AluOutExecute_inst1(AluOutExecute_inst1), .ReadData2Execute_inst1(readData2_EX_inst1),  
    .dest_reg_inst1_EX(dest_reg_inst1_EX), .MemReadEn_inst1_EX(MemReadEn_inst1_EX), .MemWriteEn_inst1_EX(MemWriteEn_inst1_EX),  
    .RegWriteEn_inst1_EX(RegWriteEn_inst1_EX), .MemtoReg_inst1_EX(MemtoReg_inst1_EX), .RegDst_inst1_EX(RegDst_inst1_EX), .AluOutMem_inst1(AluOutMem_inst1), 

    .ReadData2Mem_inst1(ReadData2Mem_inst1),.dest_reg_inst1_Mem(dest_reg_inst1_Mem) ,
    .MemReadEn_inst1_Mem(MemReadEn_inst1_Mem), .MemWriteEn_inst1_Mem(MemWriteEn_inst1_Mem), .RegWriteEn_inst1_Mem(RegWriteEn_inst1_Mem),  
    .MemtoReg_inst1_Mem(MemtoReg_inst1_Mem), .RegDst_inst1_Mem(RegDst_inst1_Mem));


EX_MEM_inst2Pipe EX_MEM_INST2_PIPE (.clk(clk), .reset(reset), .AluOutExecute_inst2(AluOutExecute_inst2), .ReadData2Execute_inst2(readData2_EX_inst2),  
    .dest_reg_inst2_EX(dest_reg_inst2_EX), .pcPlus2_EX(pcPlus2_EX), .flush1_B(flush1_B),  .flush_inst2_B(flush_inst2_B),
    .MemReadEn_inst2_EX(MemReadEn_inst2_EX), .MemWriteEn_inst2_EX(MemWriteEn_inst2_EX), .RegWriteEn_inst2_EX(RegWriteEn_inst2_EX),  
    .MemtoReg_inst2_EX(MemtoReg_inst2_EX), .RegDst_inst2_EX(RegDst_inst2_EX), .AluOutMem_inst2(AluOutMem_inst2), 
    .ReadData2Mem_inst2(ReadData2Mem_inst2), .dest_reg_inst2_Mem (dest_reg_inst2_Mem), .pcPlus2_Mem(pcPlus2_Mem), .MemReadEn_inst2_Mem(MemReadEn_inst2_Mem),  
    .MemWriteEn_inst2_Mem(MemWriteEn_inst2_Mem), .RegWriteEn_inst2_Mem(RegWriteEn_inst2_Mem), .MemtoReg_inst2_Mem(MemtoReg_inst2_Mem), .RegDst_inst2_Mem(RegDst_inst2_Mem));




DataMemory DM  (.address_a(AluOutMem_inst1[10:0]), .address_b(AluOutMem_inst2[10:0]), .clock(~clk), .data_a(ReadData2Mem_inst1), .data_b(ReadData2Mem_inst2), 
 .rden_a(MemReadEn_inst1_Mem), .rden_b(MemReadEn_inst2_Mem), .wren_a(MemWriteEn_inst1_Mem), .wren_b(MemWriteEn_inst2_Mem), .q_a(Memory_Read_Data_inst1),
  .q_b(Memory_Read_Data_inst2));
always (*) 
    begin
        NEWRegWriteEn_inst1=RegWriteEn_inst1_Mem;
        if( (RegWriteEn_inst1_Mem && RegWriteEn_inst2_Mem && (dest_reg_inst1_Mem == dest_reg_inst2_Mem )&& (dest_reg_inst1_Mem != 0) ))
            NEWRegWriteEn_inst1=1'd0;
    end

Mux3to1 WRITE_BACK_MUX_INST1 #(32) (.in1(AluOutMem_inst1),.in2(Memory_Read_Data_inst1),.in3({24'b0,pcPlus2_Mem}),.s(MemtoReg_inst1_Mem),.out(writeData_inst1));

Mux3to1 WRITE_BACK_MUX_INST2 #(32) (.in1(AluOutMem_inst2),.in2(Memory_Read_Data_inst2),.in3({24'b0,pcPlus2_Mem}),.s(MemtoReg_inst2_Mem),.out(writeData_inst2));

/************************WRITE BACK STAGE**************************************/

MEM_WB_inst1Pipe  MEM_WB_INST1_PIPE (.clk(clk), .reset(reset), .MemReadDataMem_inst1(Memory_Read_Data_inst1), .AluResultMem_inst1(AluOutMem_inst1),  
    .dest_reg_inst1_Mem(dest_reg_inst1_Mem), .MemtoRegMem_inst1(MemtoRegMem_inst1), .RegWriteEn_inst1_Mem(NEWRegWriteEn_inst1),  
    .MemReadDataWB_inst1(MemReadDataWB_inst1), .AluResultWB_inst1(AluResultWB_inst1),.dest_reg_inst1_WB(dest_reg_inst1_WB),  
    .MemtoRegWB_inst1(MemtoRegWB_inst1), .RegWriteEn_inst1_WB(RegWriteEn_inst1_WB));


MEM_WB_inst2Pipe  MEM_WB_INST1_PIPE (.clk(clk), .reset(reset), .pcPlus2_Mem(pcPlus2_Mem), .MemReadDataMem_inst2(Memory_Read_Data_inst2), 
    .AluResultMem_inst2(AluOutMem_inst2),
    .dest_reg_inst2_Mem(dest_reg_inst2_Mem), .MemtoRegMem_inst2(MemtoReg_inst2_Mem), .RegWriteEn_inst2_Mem(RegWriteEn_inst2_Mem),
    .pcPlus2_WB(pcPlus2_WB), .MemReadDataWB_inst2(MemReadDataWB_inst2), .AluResultWB_inst2(AluResultWB_inst2),
    .dest_reg_inst2_WB(dest_reg_inst2_WB), .MemtoRegWB_inst2(MemtoRegWB_inst2), .RegWriteEn_inst2_WB(RegWriteEn_inst2_WB));





endmodule
