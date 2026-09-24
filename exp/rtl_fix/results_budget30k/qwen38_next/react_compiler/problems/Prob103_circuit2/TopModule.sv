module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Truth table shows q = 1 exactly when an even number of inputs are 1,
    // i.e., q is the 4-input XNOR of a, b, c, d.
    assign q = ~(a ^ b ^ c ^ d);

endmodule
