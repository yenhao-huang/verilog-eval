module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

    // ab = 00 -> f = c + d          (2-to-1 mux, select = c)
    assign mux_in[0] = c ? 1'b1 : d;

    // ab = 01 -> f = 0              (constant)
    assign mux_in[1] = 1'b0;

    // ab = 11 -> f = c . d          (2-to-1 mux, select = c)
    assign mux_in[2] = c ? d : 1'b0;

    // ab = 10 -> f = c + d'         (2-to-1 mux, select = d)
    assign mux_in[3] = d ? c : 1'b1;

endmodule
