module top_module(
	input x,
	input y,
	output z);

    // z is a wire, so drive it with a continuous assignment.
    // From the waveform: z = 1 when x == y  ->  XNOR
    assign z = ~(x ^ y);

endmodule
