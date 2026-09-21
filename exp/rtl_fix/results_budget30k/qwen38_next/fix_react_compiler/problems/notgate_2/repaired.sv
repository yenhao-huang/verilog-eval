module top_module(
	input in,
	output out
);

	// NOT gate implemented directly with a continuous assignment
	assign out = ~in;

endmodule
