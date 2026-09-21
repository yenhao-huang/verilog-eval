module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // ab = 00 -> mux_in[0] = c OR d, implemented as 2-to-1 mux: c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // ab = 01 -> mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // ab = 11 -> mux_in[2] = c
    assign mux_in[2] = c;

    // ab = 10 -> mux_in[3] = c OR !d, implemented as 2-to-1 mux: d ? c : 1
    assign mux_in[3] = d ? c : 1'b1;

endmodule
