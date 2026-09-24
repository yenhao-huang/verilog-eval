module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);
    // out_both[i] is 1 if in[i] and in[i+1] are both 1.
    // out_both[99] is 0.
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any[i] is 1 if in[i] or in[i-1] are 1.
    // out_any[0] is 0.
    assign out_any = {(in[99:1] | in[98:0]), 1'b0};

    // out_different[i] is 1 if in[i] is different from its neighbor to the left (in[i+1]).
    // For i=99, the neighbor to the left is in[0].
    assign out_different = {(in[99] ^ in[0]), (in[98:0] ^ in[99:1])};
endmodule
