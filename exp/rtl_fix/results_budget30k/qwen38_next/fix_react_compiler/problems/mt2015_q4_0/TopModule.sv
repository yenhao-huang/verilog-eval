module top_module(
	input x,
	input y,
	output z);

	wire a1_out, b1_out, a2_out, b2_out, or_out, and_out, xor_out;

	// Module A: z = (x^y) & x   (inlined, instantiated twice)
	// Module B: z = ~(x^y)      (XNOR, from the waveform, instantiated twice)
	assign a1_out = (x ^ y) & x;
	assign b1_out = ~(x ^ y);
	assign a2_out = (x ^ y) & x;
	assign b2_out = ~(x ^ y);

	// Gates: use positional/assign form, never named ports for primitives
	assign or_out  = a1_out | b1_out;
	assign and_out = a2_out & b2_out;
	assign xor_out = or_out ^ and_out;

	assign z = xor_out;

endmodule
