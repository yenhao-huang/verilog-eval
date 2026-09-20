module top_module(
	input x,
	input y,
	output z);

	wire a1, b1, a2, b2;

	// Module A: z = (x ^ y) & x
	assign a1 = (x ^ y) & x;
	assign a2 = (x ^ y) & x;

	// Module B from waveform: z = ~(x ^ y)
	assign b1 = ~(x ^ y);
	assign b2 = ~(x ^ y);

	// OR of first A and B, AND of second A and B, then XOR
	assign z = (a1 | b1) ^ (a2 & b2);

endmodule
