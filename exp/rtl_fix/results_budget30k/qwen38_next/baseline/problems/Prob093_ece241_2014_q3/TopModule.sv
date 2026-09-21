module TopModule (
    input  wire       c,
    input  wire       d,
    output wire [3:0] mux_in
);

    // Each ternary operator below is one 2-to-1 multiplexer:
    //   sel ? i1 : i0

    // ab = 00 -> mux_in[0] = c + d
    wire mux0 = d ? 1'b1 : c;

    // ab = 01 -> mux_in[1] = 0
    wire mux1 = 1'b0;

    // ab = 11 -> mux_in[2] = c * d
    wire mux2 = d ? c : 1'b0;

    // ab = 10 -> mux_in[3] = c + ~d
    wire mux3 = d ? c : 1'b1;

    // mux_in[3] corresponds to ab = 10
    // mux_in[2] corresponds to ab = 11
    // mux_in[1] corresponds to ab = 01
    // mux_in[0] corresponds to ab = 00
    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule
