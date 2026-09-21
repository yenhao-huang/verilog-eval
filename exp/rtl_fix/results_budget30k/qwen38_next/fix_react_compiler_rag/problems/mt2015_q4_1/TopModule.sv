module top_module(
	input x,
	input y,
	output z);

    // Outputs of the two A submodules (z = (x^y) & x)
    wire a1, a2;
    // Outputs of the two B submodules (XNOR, from the waveform)
    wire b1, b2;
    // Gate outputs
    wire or_out, and_out;

    // First A and B pair -> OR gate
    assign a1 = (x ^ y) & x;
    assign b1 = ~(x ^ y);
    assign or_out = a1 | b1;

    // Second A and B pair -> AND gate
    assign a2 = (x ^ y) & x;
    assign b2 = ~(x ^ y);
    assign and_out = a2 & b2;

    // Final XOR
    assign z = or_out ^ and_out;

endmodule
