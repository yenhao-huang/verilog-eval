module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] -> ab = 00 : f = c | d
    // mux_in[1] -> ab = 01 : f = 0
    // mux_in[2] -> ab = 11 : f = c & d
    // mux_in[3] -> ab = 10 : f = c | ~d
    // Each is built as a 2-to-1 mux with select = d (no other gates used).

    assign mux_in[0] = d ? 1'b1 : c;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = d ? c : 1'b0;
    assign mux_in[3] = d ? c : 1'b1;

endmodule
