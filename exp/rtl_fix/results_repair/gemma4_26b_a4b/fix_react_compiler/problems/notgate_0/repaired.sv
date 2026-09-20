module top_module(
	input in,
	output logic out
);

always_comb
	out = ~in;
endmodule
