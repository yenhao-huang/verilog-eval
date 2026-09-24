module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Sum of the two 8-bit operands (lower 8 bits of the addition)
    assign s = a + b;

    // Signed (two's complement) overflow occurs when:
    //   two positive operands produce a negative result, or
    //   two negative operands produce a positive result
    assign overflow = (~a[7] & ~b[7] &  s[7]) |   // pos + pos -> neg
                      ( a[7] &  b[7] & ~s[7]);    // neg + neg -> pos

endmodule
