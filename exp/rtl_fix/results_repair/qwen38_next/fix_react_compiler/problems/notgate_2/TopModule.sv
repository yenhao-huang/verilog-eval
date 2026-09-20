module top_module(
	input in,
	output out
);

	assign out = ~in;   // NOT gate implemented directly (equivalently: not(out, in);)

endmodule
