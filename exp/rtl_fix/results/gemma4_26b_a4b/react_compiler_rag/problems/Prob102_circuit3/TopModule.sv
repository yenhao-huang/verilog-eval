module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // The circuit is a combinational circuit.
    // Based on the truth table provided:
    // q = 1 when (a=0, b=1, c=0, d=1), (a=0, b=1, c=1, d=0), (a=0, b=1, c=1, d=1),
    //     (a=1, b=0, c=0, d=1), (a=1, b=0, c=1, d=0), (a=1, b=0, c=1, d=1),
    //     (a=1, b=1, c=0, d=1), (a=1, b=1, c=1, d=0), (a=1, b=1, c=1, d=1).
    // This can be simplified using a K-map or Boolean algebra to:
    // q = (a | b) & (c | d)
    assign q = (a | b) & (c | d);
endmodule
