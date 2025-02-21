module MEM_WB_inst1Pipe (
    input clk,
    input reset,
    input [31:0] MemReadDataMem_inst1,
    input [31:0] AluResultMem_inst1,
    input [4:0] dest_reg_inst1_Mem,
    input [1:0] MemtoRegMem_inst1,
    input RegWriteEn_inst1_Mem ,

    output reg [31:0] MemReadDataWB_inst1,
    output reg [31:0] AluResultWB_inst1 ,
    output reg [4:0] dest_reg_inst1_WB,
    output reg [1:0] MemtoRegWB_inst1,
    output reg RegWriteEn_inst1_WB 
    
    );

always @(posedge clk, negedge reset) 
    begin
        if(~reset)
        begin

        MemReadDataWB_inst1 <= 32'b0;
        AluResultWB_inst1<= 32'b0;
        dest_reg_inst1_WB <= 5'b0;
        MemtoRegWB_inst1<= 2'b0;
        RegWriteEn_inst1_WB<= 2'b0 ;
           
        end
		  
		else 
		begin
        MemReadDataWB_inst1 <=MemReadDataMem_inst1;
        AluResultWB_inst1<= AluResultMem_inst1;
        dest_reg_inst1_WB <= dest_reg_inst1_Mem;
        MemtoRegWB_inst1 <=MemtoRegMem_inst1;
        RegWriteEn_inst1_WB <=RegWriteEn_inst1_Mem;
           
       end 

		end 
    endmodule
