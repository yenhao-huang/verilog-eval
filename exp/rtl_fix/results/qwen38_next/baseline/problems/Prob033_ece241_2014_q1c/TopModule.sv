module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // 8-bit sum, discarding any carry out of bit 7
    assign s = a + b;

    // Signed overflow:
    // positive + positive = negative
    // negative + negative = positive
    assign overflow = (~a[7] & ~b[7] &  s[7]) |
                      ( a[7] &  b[7] & ~s[7]);

endmodule
