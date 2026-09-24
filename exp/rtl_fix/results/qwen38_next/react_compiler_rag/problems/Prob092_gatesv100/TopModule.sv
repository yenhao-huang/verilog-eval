module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1]; out_both[99] = 0 (no left neighbour)
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any[i] = in[i] | in[i-1]; out_any[0] = 0 (no right neighbour)
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different[i] = in[i] ^ in[i+1], with wrap-around for bit 99
    assign out_different = {in[99] ^ in[0], in[98:0] ^ in[99:1]};

endmodule
