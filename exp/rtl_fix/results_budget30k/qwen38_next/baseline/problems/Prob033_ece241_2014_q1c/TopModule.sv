module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // 8-bit sum, truncated to 8 bits
    assign s = a + b;

    // Signed overflow occurs when:
    // positive + positive = negative, or
    // negative + negative = positive
    assign overflow = (~a[7] & ~b[7] &  s[7]) |
                      ( a[7] &  b[7] & ~s[7]);

endmodule
