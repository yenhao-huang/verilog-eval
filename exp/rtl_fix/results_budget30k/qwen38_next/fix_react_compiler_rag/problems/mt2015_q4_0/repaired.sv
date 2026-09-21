module top_module(
	input x,
	input y,
	output z);

    wire a_out;
    wire b_out;
    wire or_out;
    wire and_out;

    // Module A: z = (x^y) & x
    assign a_out = (x ^ y) & x;

    // Module B: from waveform -> XNOR
    assign b_out = ~(x ^ y);

    // OR of A and B, AND of A and B, then XOR them
    assign or_out  = a_out | b_out;
    assign and_out = a_out & b_out;

    assign z = or_out ^ and_out;

endmodule
