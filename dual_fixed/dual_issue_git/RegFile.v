

module RegFile (clk, rst, WriteEnable_inst1, WriteEnable_inst2,
					 readRegister1_inst1, readRegister2_inst1, writeRegister_inst1,
					 writeData_inst1, readData1_inst1, readData2_inst1,
					 readRegister1_inst2, readRegister2_inst2, writeRegister_inst2,
					 writeData_inst2, readData1_inst2, readData2_inst2);

	// inputs
	input wire clk, rst, WriteEnable_inst1, WriteEnable_inst2 ;
	input wire [4:0] readRegister1_inst1, readRegister2_inst1, writeRegister_inst1, readRegister1_inst2, readRegister2_inst2, writeRegister_inst2;
	input wire [31:0] writeData_inst1, writeData_inst2;
	// outputs
	output wire [31:0] readData1_inst1, readData2_inst1, readData1_inst2, readData2_inst2 ;

	reg [31:0] registers [31:0];
	

	// Read from the register file

	//instruction1
	assign readData1_inst1 = registers[readRegister1_inst1];
   	assign readData2_inst1  = registers[readRegister2_inst1];
	//instruction2
	assign readData1_inst2 = registers[readRegister1_inst2];
	assign readData2_inst2 = registers[readRegister2_inst2];
	 
	
	always@(negedge clk,  negedge rst) begin : Write_on_register_file_block
	
		integer i;
		// Reset the register file
		if(~rst) begin
			for(i=0; i<32; i = i + 1)
				registers[i] = 0;
		end
		// Write to the register file
		
		else
			begin
			
			if(WriteEnable_inst1 & (writeRegister_inst1 != 0 ))
					registers[writeRegister_inst1] <= writeData_inst1;
			else;	
				
			if(WriteEnable_inst2 & (writeRegister_inst2 != 0 ))
				registers[writeRegister_inst2] <= writeData_inst2;
			else;
		end
		// Defualt to prevent latching
		
	end

endmodule
