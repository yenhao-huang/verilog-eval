module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] for ab = 00: function c OR d, implemented as a 2-to-1 mux
    assign mux_in[0] = d ? 1'b1 : c;

    // mux_in[1] for ab = 01: constant 0, no mux needed
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab = 11: function c AND d, implemented as a 2-to-1 mux
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] for ab = 10: function c OR (NOT d), implemented as a 2-to-1 mux
    assign mux_in[3] = d ? c : 1'b1;

endmodule
