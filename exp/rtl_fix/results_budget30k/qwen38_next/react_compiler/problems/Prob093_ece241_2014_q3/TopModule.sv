module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] corresponds to ab = 00: c + d
    assign mux_in[0] = d ? 1'b1 : c;

    // mux_in[1] corresponds to ab = 01: 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] corresponds to ab = 11: c * d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] corresponds to ab = 10: c + d'
    assign mux_in[3] = d ? c : 1'b1;

endmodule
