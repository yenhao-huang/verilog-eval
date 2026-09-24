module top_module(
	input a, 
	input b,
	output out
);

	// NOR gate: out is 1 only when both a and b are 0
	assign out = ~(a | b);

endmodule
