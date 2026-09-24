module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // The circuit is a combinational circuit that implements the XNOR of the four inputs.
    // Based on the truth table provided:
    // a b c d | q
    // 0 0 0 0 | 1
    // 0 0 0 1 | 0
    // 0 0 1 0 | 0
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 0
    // 1 0 0 0 | 0
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 0
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1
    // The output q is 1 when the number of 1s in the input is even, which is the XNOR operation.
    assign q = ~(a ^ b ^ c ^ d);
endmodule
