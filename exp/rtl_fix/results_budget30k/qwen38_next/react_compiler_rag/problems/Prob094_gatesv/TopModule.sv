module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both      = in & (in >> 1);
    assign out_any       = in | (in << 1);
    assign out_different = in ^ {in[0], in[3:1]};

endmodule
