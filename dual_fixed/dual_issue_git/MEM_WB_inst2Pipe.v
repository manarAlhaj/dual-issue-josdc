module MEM_WB_inst2Pipe (
    input clk,
    input reset,

    //input [7:0] pcPlus2_Mem,
    //input [31:0] MemReadDataMem_inst2,
    //input [31:0] AluResultMem_inst2,
    input [4:0] dest_reg_inst2_Mem,
    input [31:0] writeData_inst2_Mem,
    //input [1:0] MemtoRegMem_inst2,
    input RegWriteEn_inst2_Mem,

    //output reg [7:0] pcPlus2_WB,
    //output reg [31:0] MemReadDataWB_inst2,
    //output reg [31:0] AluResultWB_inst2 ,
    output reg [4:0] dest_reg_inst2_WB,
   // output reg [1:0] MemtoRegWB_inst2,
	 output reg [31:0] writeData_inst2_WB,
    output reg RegWriteEn_inst2_WB 
    

);

always @(posedge clk, negedge reset) 
    begin
        if(~reset)
		  
        begin
			  //pcPlus2_WB <= 8'b0;
			  //MemReadDataWB_inst2<= 32'b0;
			  //AluResultWB_inst2<= 32'b0;
			  dest_reg_inst2_WB<= 5'b0;
			  //MemtoRegWB_inst2<= 2'b0;
			  writeData_inst2_WB<= 32'b0;
			  RegWriteEn_inst2_WB<= 1'b0 ;
           
        end
   
    else 
	 
    begin
        //pcPlus2_WB <= pcPlus2_Mem;
       // MemReadDataWB_inst2 <=MemReadDataMem_inst2;
        //AluResultWB_inst2<= AluResultMem_inst2;
        dest_reg_inst2_WB <= dest_reg_inst2_Mem;
        //MemtoRegWB_inst2<= MemtoRegMem_inst2;
		  writeData_inst2_WB <= writeData_inst2_Mem;
        RegWriteEn_inst2_WB<= RegWriteEn_inst2_Mem ;
     end 
	  
    end 

   

endmodule 