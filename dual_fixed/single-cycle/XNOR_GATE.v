module XNOR_GATE(in1,in2,out);

input in1, in2;
output out;
assign out = ~(in1 ^ in2);


endmodule 