module top_module(
	input a, 
	input b,
	output out
);

xnor xnor_gate(out, a, b);

endmodule
