module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1]   (bit 3 unused)
    assign out_both = in & (in >> 1);

    // out_any[i] = in[i] | in[i-1]    (bit 0 unused)
    assign out_any = in | (in << 1);

    // out_different[i] = in[i] ^ left neighbour, with in[3] wrapping to in[0]
    assign out_different = in ^ {in[0], in[3:1]};

endmodule
