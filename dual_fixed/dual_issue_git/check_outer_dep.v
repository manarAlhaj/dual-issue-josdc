// module check_outer_dep (
//     input [4:0] Rs_D_inst1,
//     input [4:0] Rs_D_inst2,
//     input [4:0] Rt_D_inst1,
//     input [4:0] Rt_D_inst2,

//     input [4:0] Rd_EX_inst1,
//     input [4:0] Rd_EX_inst2,


//     input MemReadEn_inst1_EX,
//     input MemReadEn_inst2_EX, 
//     output reg outer_depend
// );
    
//     reg dep_upper_upper, dep_upper_lower, dep_lower_upper, dep_lower_lower;


// always @(*) begin
//     outer_depend=0;
//     dep_upper_upper = (MemReadEn_inst1_EX & ((Rd_EX_inst1 == Rs_D_inst1)
//     || (Rd_EX_inst1 == Rt_D_inst1)) & (Rd_EX_inst1 != 5'b0));

//     dep_upper_lower = (MemReadEn_inst1_EX & ((Rd_EX_inst1 == Rs_D_inst2)
//     || (Rd_EX_inst1 == Rt_D_inst2)) & (Rd_EX_inst1 != 5'b0));

//     dep_lower_upper = (MemReadEn_inst2_EX & ((Rd_EX_inst2 == Rs_D_inst1)
//     || (Rd_EX_inst2 == Rt_D_inst1)) & (Rd_EX_inst2 != 5'b0));

//     dep_lower_lower = (MemReadEn_inst2_EX & ((Rd_EX_inst2 == Rs_D_inst2)
//     || (Rd_EX_inst2 == Rt_D_inst2)) & (Rd_EX_inst2 != 5'b0)); 

//     outer_depend =  dep_upper_upper | dep_upper_lower | dep_lower_upper | dep_lower_lower ; //stall 
// end
    

// endmodule