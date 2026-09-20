module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // The truth table shows that q is 1 when the number of 1s in the input (a, b, c, d) is even.
    // This is equivalent to the XNOR of the four inputs.
    assign q = ~(a ^ b ^ c ^ d);
endmodule
