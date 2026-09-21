module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map columns in the order 00, 01, 11, 10:
    // mux_in[0] = c | d
    // mux_in[1] = 0
    // mux_in[2] = c
    // mux_in[3] = c | ~d
    //
    // The combinational logic is written using mux-like ternary operators.
    assign mux_in[0] = c ? 1'b1 : d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c;
    assign mux_in[3] = d ? c : 1'b1;
endmodule
