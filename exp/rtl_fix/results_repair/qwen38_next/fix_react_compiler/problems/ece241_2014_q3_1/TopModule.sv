module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

    // mux_in[0] -> ab = 00 column: f = c OR d  (2-to-1 mux: sel=c, in0=d, in1=1)
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] -> ab = 01 column: f = 0 (no mux needed)
    assign mux_in[1] = 1'b0;

    // mux_in[2] -> ab = 11 column: f = c AND d (2-to-1 mux: sel=c, in0=0, in1=d)
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] -> ab = 10 column: f = c OR ~d (2-to-1 mux: sel=d, in0=1, in1=c)
    assign mux_in[3] = d ? c : 1'b1;

endmodule
