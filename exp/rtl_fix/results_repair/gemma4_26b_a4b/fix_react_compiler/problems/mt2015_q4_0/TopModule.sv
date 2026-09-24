module top_module(
	input x,
	input y,
	output z);

    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

    // Module A: z = (x ^ y) & x
    assign a1_out = (x ^ y) & x;
    assign a2_out = (x ^ y) & x;

    // Module B: z = ~(x ^ y) (derived from waveform)
    assign b1_out = ~(x ^ y);
    assign b2_out = ~(x ^ y);

    // OR gate for the first pair
    assign or_out = a1_out | b1_out;

    // AND gate for the second pair
    assign and_out = a2_out & b2_out;

    // XOR gate for the final output
    assign z = or_out ^ and_out;

endmodule
