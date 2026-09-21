module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

    // ab = 00 column: F = c | d  (one 2:1 mux: sel = c, in1 = 1, in0 = d)
    assign mux_in[0] = c ? 1'b1 : d;

    // ab = 01 column: F = 0      (tie to constant 0, no mux needed)
    assign mux_in[1] = 1'b0;

    // ab = 11 column: F = c & d  (one 2:1 mux: sel = c, in1 = d, in0 = 0)
    assign mux_in[2] = c ? d : 1'b0;

    // ab = 10 column: F = c | ~d (one 2:1 mux: sel = d, in1 = c, in0 = 1)
    assign mux_in[3] = d ? c : 1'b1;

endmodule
