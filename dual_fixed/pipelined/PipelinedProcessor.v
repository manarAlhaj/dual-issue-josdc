module PipelinedProcessor(clock, reset, pcFetch);
    input clock, reset;
    output [5:0] pcFetch;

    wire [5:0] pcPlus1F,pcPlus1D,pcD,pcF,pcPlus1EX,pcPlus1Mem,pcPlus1WB,branchMuxOut,opcodeDecode,functDecode,
    jumpTypeMuxOut,pcSrcDMuxOut, pcBranchD;  
    wire [31:0] instructionFetch, instructionDecode,extendedImmediateD,readData1Decode, readData2Decode,aluResultExecute, writeDataE, AluSrcA_E, AluSrcB_E,
    readData1Execute, readData2Execute,aluResultMem,writeDataMem, memoryReadDataMem,FwdADMuxOut,FwdBDMuxOut,immExecute,
    aluResultWB, memoryReadDataWB,memToRegMuxOut, AluResultMem; 
    wire branchAndOut, xnorOut, stall, flush;
    wire [15:0]immDecode;
    wire [1:0] MemtoRegDecode, MemtoRegEnExecute,MemtoRegEnMem,MemtoRegEnWB;
    wire RegDstDecode, RegDstExecute, RegDstMem,RegDstWB, equal, ALUSrcDecode, MemReadEnDecode, MemWriteEnDecode, ALUSrcExecute, MemReadEnExecute, MemWriteEnExecute,
    RegWriteEnDecode, jumpDecode, sign_ExtDecode, BranchDecode, RegWriteEnExecute,
    OVF_E, ZeroExecute, memory_out_of_boundE, MemReadEnMem, MemWriteEnMem,RegWriteEnMem,RegWriteEnWB;
    wire prediction, actual_prediction, PCsrcDecode;
    wire [3:0] ALUOpExecute,ALUOpDecode;
    wire [4:0] rsDecode, rtDecode, rdDecode, shamtDecode, rsExecute, rtExecute, rdExecute, shamtExecute,WriteRegExecute,rdMem,
	 rd_or_rt_M,rd_or_rt_WB, DestMuxOut;
    wire [1:0] forwardA, forwardB;
	 
    
    // -----------------------------------------FETCH STAGE---------------------------------------
    // to tell if beq or bnq
    XnorGate XnorBranch(.in1(~equal), .in2(instructionDecode[26]), .out(xnorOut));
   // the one in the decode stage
    ANDGate branchAnd(.in1(xnorOut), .in2(BranchDecode), .out(branchAndOut));
    // branch target address or pc+1
    Mux2to1 #(6) branchMux(.in1(pcPlus1F), .in2(pcBranchD), .s(branchAndOut), .out(branchMuxOut));
    //jump target for jump or jumpr
    Mux2to1 #(6) jumpTypeMux(.in1(readData1Decode[5:0]), .in2(immDecode[5:0]), .s(jumpDecode), .out(jumpTypeMuxOut));
   
    Mux2to1 #(6) pcSrcDMux(.in1(branchMuxOut), .in2(jumpTypeMuxOut), .s(PCsrcDecode), .out(pcSrcDMuxOut));

    // added flush+stall on pc to flush+ stall when wrong instructions.
    ProgramCounter programCounter(.clk(clock), .reset(reset), .PCin(pcSrcDMuxOut), .PCout(pcFetch), .stall(stall),.flush(flush));

    //pc+1
    Adder pcAdderF(.in1(pcFetch), .in2(6'd1), .out(pcPlus1F));
    
    //IM
    InstructionMemory instructionMemory(.address(pcFetch), .clock(clock), .q(instructionFetch));

    //Fetch - Decode reg 
    IF_ID_Reg if_id_reg(.instructionFetch(instructionFetch), .pcPlus1F(pcPlus1F),.pcF(pcF) ,.clk(clock), .reset(reset),.stall(stall), .flush(flush),
     .instructionDecode(instructionDecode),.pcPlus1D(pcPlus1D), .pcD(pcD));
   // stall isnt nulling and isnt restart //manar: ?? 


    // ----------------------------------------------DECODE STAGE--------------------------------------------------

    assign opcodeDecode = instructionDecode[31:26];
    assign functDecode  = instructionDecode[5:0]; 
    assign rsDecode = instructionDecode[25:21];
    assign rtDecode = instructionDecode[20:16];  
    assign rdDecode = instructionDecode[15:11];  
    assign immDecode = instructionDecode[15:0];
    assign shamtDecode = instructionDecode[10:6];

    //modified the hdu, added the required control signals which are the prediction and the actual pred //manar
    HazardDetectionUnit hazardDetectionUnit(.EXMEM_Rd(rtExecute), .IDEX_Rs(rsDecode), .IDEX_Rt(rtDecode), .MemRead(MemReadEnDecode), .prediction(prediction)
    ,.actual_prediction(actual_prediction), .PCsrc(PCsrcDecode), .flush(flush), .stall(stall));

    Adder branch_target_address_D(.in1(immDecode[5:0]), .in2(pcPlus1D), .out(pcBranchD)); //Branch TA in decode manar
  
   gshare_branch_predictor BPU (.clk (clock),.reset(reset), .branch(BranchDecode),.pc(pcD),.branch_taken(xnorOut)
   ,.prediction(actual_prediction)); 
   
    
    ControlUnit controlUnit(.opcode(opcodeDecode), .funct(functDecode), .RegDst(RegDstDecode), .Branch(BranchDecode),
     .MemReadEn(MemReadEnDecode), .MemtoReg(MemtoRegDecode), .ALUOp(ALUOpDecode), .MemWriteEn(MemWriteEnDecode), 
     .RegWriteEn(RegWriteEnDecode), .ALUSrc(ALUSrcDecode), .JUMP(jumpDecode), .sign_ext(sign_ExtDecode), .PCsrc(PCsrcDecode));

    SignExtender signExtender(.immediate(immDecode), .signExtend(sign_ExtDecode), .extendedImmediate(extendedImmediateD));


    // choose destination reg if rd (r type) rt (lw) reg31  (jump and link) 
    Mux2to1 #(5) DestRegMux(.in1(rd_or_rt_WB),.in2(5'd31), .s(RegDstWB), .out(DestMuxOut));

    RegisterFile registerFile(.clk(clock), .rst(reset), .we(RegWriteEnWB), .readRegister1(rsDecode), .readRegister2(rtDecode),
     .writeRegister(DestMuxOut), .writeData(memToRegMuxOut), .readData1(readData1Decode), .readData2(readData2Decode));

   
    Mux2to1 #(32) FwdADMux(.in1(readData1Decode), .in2(aluResultMem), .s(forwardA[0]), .out(FwdADMuxOut));
    Mux2to1 #(32) FwdBDMux(.in1(readData2Decode), .in2(aluResultMem), .s(forwardB[0]), .out(FwdBDMuxOut));
    
    // equal here can be used as a zero flag for the branch signal - manar
    Comparator comparator(.in1(FwdADMuxOut), .in2(FwdBDMuxOut), .out(equal));
  
    //since we are resolving the branch in decode stage, the signals related to it isn't required to be propagated
    //.BranchDecode(BranchDecode) is removed
    //.BranchExecute(BranchExecute) is removed -manar

    //we may need to propagate the jump 
    //what about pcsrc decode? hmm combinational logic must calculate immediatly? maybe
    // we dont need to propagate it, i'll leave it for after testing.
    //a7a why the hell are we propagating the whole instruction with in D/E pipe??? .instructionDecode and  instructionExecute are removed - manar

    ID_EX_Reg id_ex_reg(
        .clk(clock), .reset(reset),.MemReadEnDecode(MemReadEnDecode), .MemWriteEnDecode(MemWriteEnDecode), .RegWriteEnDecode(RegWriteEnDecode),
        .ALUSrcDecode(ALUSrcDecode),.stall(stall), .RegDstDecode(RegDstDecode), .MemtoRegDecode(MemtoRegDecode),
        .ALUOpDecode(ALUOpDecode), .shamtDecode(shamtDecode), .rdDecode(rdDecode),.rsDecode(rsDecode), .rtDecode(rtDecode), .pcPlus1D(pcPlus1D),
        .readData1Decode(readData1Decode), .readData2Decode(readData2Decode), .immDecode(extendedImmediateD),.MemReadEnExecute(MemReadEnExecute),
        .MemWriteEnExecute(MemWriteEnExecute), .RegWriteEnExecute(RegWriteEnExecute), .ALUSrcExecute(ALUSrcExecute),
         .RegDstExecute(RegDstExecute), .MemtoRegExecute(MemtoRegEnExecute), .ALUOpExecute(ALUOpExecute), .shamtExecute(shamtExecute), .rdExecute(rdExecute),
        .rtExecute(rtExecute),.rsExecute(rsExecute), .pcPlus1EX(pcPlus1EX), .readData1Execute(readData1Execute), .readData2Execute(readData2Execute), .immExecute(immExecute)
    );

    // -------------------------------------------------EXECUTE STAGE---------------------------------
       
    //-manar
    //picks either rt or rd based on the instruction type to use in alu unit
    Mux2to1 #(5) regDstEMux(.in1(rtExecute), .in2(rdExecute), .s(RegDstExecute), .out(WriteRegExecute)); //pick either rt/rd 

    Mux3to1 #(32) aluFwdAEMux(.in1(readData1Execute), .in2(memToRegMuxOut), .in3(aluResultMem), .s(forwardA), .out(AluSrcA_E)); //forwarding unit A

    //writeDataE needs to be propagated in order to use it for sw purposes (store the value of rt in memory)
    Mux3to1 #(32) aluFwdBEMux(.in1(readData2Execute), .in2(memToRegMuxOut), .in3(aluResultMem), .s(forwardB), .out(writeDataE)); //forwarding unit B
    // the second alu operand is either the imm (sw/lw) or the normal reg values either normal or forwarded ones.
    Mux2to1 #(32) aluSrcEMux(.in1(writeDataE), .in2(immExecute), .s(ALUSrcExecute), .out(AluSrcB_E));
	 
    ALU alu(.ALUop(ALUOpExecute), .op1(AluSrcA_E), .op2(AluSrcB_E), .shamt(shamtExecute), .result(aluResultExecute), .OVF(OVF_E), .zero(ZeroExecute), .memory_out_of_bound(memory_out_of_boundE));

	 
	 
	 /*
	 module ForwardingUnit(
    input[4:0] Rd_mem,
    input[4:0] Rd_WB,
    input[4:0] Rs_EX,
    input[4:0] Rt_EX,
    input RegWrite_mem, //reg write control signal, 
    input RegWrite_WB,
	
    output reg [1:0] forwardA,
	output reg [1:0] forwardB

);
	 
	 
	 */
    ForwardingUnit ForwardingUnit (.Rd_mem(rd_or_rt_M),.Rd_WB(rd_or_rt_WB),.Rs_EX(rsExecute),.Rt_EX(rtExecute), .RegWrite_mem(RegWriteEnMem) , .RegWrite_WB(RegWriteEnWB),.forwardA(forwardA), .forwardB(forwardB));
  
    //  removed rt, red and reg because of WriteDataE /Write RegE (rd_or_rt) (tired to explain why)
    //  removed zeroE and zeroM signals from pipe bcz why tf i would use them in memory stage
    // Removed .branchAdderResultExecute(), branchExecute , branchMem 
        
    Ex_Mem_Reg ex_mem_reg(
        .clk(clock), .reset(reset), .AluOutExecute(aluResultExecute), .ReadData2Execute(writeDataE), .rd_or_rt_E(WriteRegExecute),
       .MemReadExecute(MemReadEnExecute), .MemWriteExecute(MemWriteEnExecute),
        .RegWriteExecute(RegWriteEnExecute), .MemtoRegExecute(MemtoRegEnExecute), .pcPlus1EX(pcPlus1EX), .RegDstExecute(RegDstExecute), .AluOutMem(aluResultMem), .ReadData2Mem(writeDataMem),
        .rd_or_rt_M(rd_or_rt_M),.MemReadMem(MemReadEnMem), .MemWriteMem(MemWriteEnMem),
        .RegWriteMem(RegWriteEnMem),.RegDstMem(RegDstMem) ,.MemtoRegMem(MemtoRegEnMem), .pcPlus1Mem(pcPlus1Mem)
    );

    // ------------------------MEMORY STAGE----------------------------------------------
    /*assign rdMem = instructionMem[15:11];
    assign rtMem = instructionMem[20:16];  
    assign rsMem = instructionMem[25:21]; */

    DataMemory dataMemory(.address(AluResultMem[5:0]), .clock(clock), .data(writeDataMem), .rden(MemReadEnMem), .wren(MemWriteEnMem), .q(memoryReadDataMem));
    

    Mem_WB_Reg mem_wb_reg(
        .clk(clock), .reset(reset), .memoryReadDataMem(memoryReadDataMem),.RegDstMem(RegDstMem),
         .AluResultMem(aluResultMem), .rd_or_rt_M(rd_or_rt_M), .MemtoRegMem(MemtoRegEnMem),
        .RegWriteMem(RegWriteEnMem), .pcPlus1Mem(pcPlus1Mem), .memoryReadDataWB(memoryReadDataWB), 
        .AluResultWB(aluResultWB), .rd_or_rt_WB(rd_or_rt_WB), .MemtoRegWB(MemtoRegEnWB),
        .RegWriteWB(RegWriteEnWB),.pcPlus1WB(pcPlus1WB),.RegDstWB(RegDstWB)
    );

    //------------------------------------ WRITEBACK STAGE---------------------

    Mux3to1 #(32) memToRegMux(.in1(aluResultWB), .in2(memoryReadDataWB), .in3({26'b0,pcPlus1WB}), .s(MemtoRegEnWB), .out(memToRegMuxOut));

endmodule
