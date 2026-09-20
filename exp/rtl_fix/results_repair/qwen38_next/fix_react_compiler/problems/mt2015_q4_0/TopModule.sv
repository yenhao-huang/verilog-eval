module top_module(
	input x,
	input y,
	output z);

	wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

	// Module A: z = (x ^ y) & x
	// Module B: z = ~(x ^ y)   (from the waveform: 1 when x == y)
	assign a1_out = (x ^ y) & x;
	assign b1_out = ~(x ^ y);
	assign a2_out = (x ^ y) & x;
	assign b2_out = ~(x ^ y);

	// Primitive gates use POSITIONAL ports: (output, in1, in2)
	or  or_gate  (or_out,  a1_out, b1_out);
	and and_gate (and_out, a2_out, b2_out);
	xor xor_gate (z,       or_out, and_out);

endmodule
