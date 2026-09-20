module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Sum of the two 8-bit operands (lower 8 bits of the result)
    assign s = a + b;

    // Signed overflow:
    //   positive + positive = negative, or
    //   negative + negative = positive
    assign overflow = (~a[7] & ~b[7] &  s[7]) |
                      ( a[7] &  b[7] & ~s[7]);

endmodule
