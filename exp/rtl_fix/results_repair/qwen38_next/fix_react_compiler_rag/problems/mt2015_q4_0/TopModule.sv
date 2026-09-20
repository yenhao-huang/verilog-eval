module top_module(
	input x,
	input y,
	output z);

	wire a, b;        // outputs of the A and B submodule logic
	wire or_out, and_out;

	// Module A: z = (x ^ y) & x
	assign a = (x ^ y) & x;

	// Module B (from waveform): z = x XNOR y
	assign b = ~(x ^ y);

	// Two-input OR  (A1 with B1)
	assign or_out  = a | b;

	// Two-input AND (A2 with B2)
	assign and_out = a & b;

	// XOR of the OR and the AND gates -> z
	assign z = or_out ^ and_out;

endmodule
