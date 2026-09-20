module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Perform 8-bit addition
    assign s = a + b;

    /* 
     * Signed overflow detection logic:
     * In 2's complement addition, overflow occurs if:
     * 1. Two positive numbers are added and the result is negative.
     * 2. Two negative numbers are added and the result is positive.
     * 
     * This can be expressed as:
     * (a[7] == b[7]) AND (s[7] != a[7])
     * 
     * Where index [7] is the sign bit.
     */
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);

endmodule
