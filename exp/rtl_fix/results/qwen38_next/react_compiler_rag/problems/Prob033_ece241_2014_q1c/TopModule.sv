module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [7:0] sum;

    assign sum = a + b;
    assign s   = sum;

    // Overflow: both operands positive but result negative, or
    //           both operands negative but result positive
    assign overflow = (~a[7] & ~b[7] &  s[7]) |
                      ( a[7] &  b[7] & ~s[7]);

endmodule
