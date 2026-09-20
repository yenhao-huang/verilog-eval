module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1], with out_both[99] = 0
    assign out_both[99]   = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any[i] = in[i] | in[i-1], with out_any[0] = 0
    assign out_any[0]     = 1'b0;
    assign out_any[99:1]  = in[99:1] | in[98:0];

    // out_different[i] = in[i] ^ in[i+1], wrapping around for i = 99
    assign out_different[99]   = in[99] ^ in[0];
    assign out_different[98:0] = in[98:0] ^ in[99:1];

endmodule
