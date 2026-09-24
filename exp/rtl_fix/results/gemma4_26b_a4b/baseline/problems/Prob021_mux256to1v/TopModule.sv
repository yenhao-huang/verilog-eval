module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // The module implements a 256-to-1 multiplexer.
    // Each selection corresponds to a 4-bit slice of the 1024-bit input.
    // Using the indexed part-select operator (+:):
    // in[base_expr +: width] selects 'width' bits starting from 'base_expr'.
    // For sel = 0, base_expr = 0, selects in[3:0].
    // For sel = 1, base_expr = 4, selects in[7:4].
    // For sel = 255, base_expr = 1020, selects in[1023:1020].

    assign out = in[sel * 4 +: 4];

endmodule
