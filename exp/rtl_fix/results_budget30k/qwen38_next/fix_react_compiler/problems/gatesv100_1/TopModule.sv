module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1]        (i = 98..0, left neighbour)
    assign out_both = in[98:0] & in[99:1];

    // out_any[i]  = in[i] | in[i-1]        (i = 99..1, right neighbour)
    assign out_any  = in[99:1] | in[98:0];

    // out_different[i] = in[i] ^ left neighbour, wrapping: in[99] vs in[0]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule
