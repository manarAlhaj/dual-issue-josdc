module EX_MEM_inst2Pipe (
    input clk,
    input reset,
    input [31:0] AluOutExecute_inst2,
    input [31:0] ReadData2Execute_inst2,
    input [4:0] dest_reg_inst2_EX,
    input [7:0] pcPlus2_EX,
    input flush_E_2,
	 input [7:0] pcE_inst2,
    input MemReadEn_inst2_EX,
    input MemWriteEn_inst2_EX,
    input RegWriteEn_inst2_EX,
    input [1:0] MemtoReg_inst2_EX,
 

    output reg [31:0] AluOutMem_inst2,
    output reg [31:0] ReadData2Mem_inst2,
    output reg [4:0] dest_reg_inst2_Mem,
    output reg [7:0] pcPlus2_Mem,

    output reg MemReadEn_inst2_Mem,
    output reg MemWriteEn_inst2_Mem,
    output reg RegWriteEn_inst2_Mem,
	  output reg [7:0] pcM_inst2,
    output reg [1:0] MemtoReg_inst2_Mem
);

always @(posedge clk, negedge reset) 
    begin
        if(~reset)
        begin
       
        AluOutMem_inst2 <= 32'b0;
        ReadData2Mem_inst2 <= 32'b0;
        dest_reg_inst2_Mem <= 5'b0;
        pcPlus2_Mem <= 8'b0;
        MemReadEn_inst2_Mem <= 1'b0;
        MemWriteEn_inst2_Mem <= 1'b0;
        RegWriteEn_inst2_Mem <= 1'b0;
        MemtoReg_inst2_Mem <= 2'b0;
			pcM_inst2 <= 8'b0;

        end
        else if (flush_E_2)
        begin
            AluOutMem_inst2 <= 32'b0;
            ReadData2Mem_inst2 <= 32'b0;
            dest_reg_inst2_Mem <= 5'b0;
            pcPlus2_Mem <= 8'b0;
            MemReadEn_inst2_Mem <= 1'b0;
            MemWriteEn_inst2_Mem <= 1'b0;
            RegWriteEn_inst2_Mem <= 1'b0;
            MemtoReg_inst2_Mem <= 2'b0;
				pcM_inst2 <= 8'b0;
       
				end
           
    else 
    begin
        AluOutMem_inst2 <= AluOutExecute_inst2;
        ReadData2Mem_inst2 <= ReadData2Execute_inst2;
        dest_reg_inst2_Mem <= dest_reg_inst2_EX;
        pcPlus2_Mem <= pcPlus2_EX;
        MemReadEn_inst2_Mem <=MemReadEn_inst2_EX;
        MemWriteEn_inst2_Mem <= MemWriteEn_inst2_EX ;
        RegWriteEn_inst2_Mem <= RegWriteEn_inst2_EX ;
        MemtoReg_inst2_Mem <= MemtoReg_inst2_EX ;
       	pcM_inst2 <= pcE_inst2; 

    end
	 
	 end

endmodule 