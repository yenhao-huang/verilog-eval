wire xnor_out;
assign xnor_out = ~(in1 ^ in2);
assign out = xnor_out ^ in3;
