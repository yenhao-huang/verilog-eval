module TopModule (
    input a,
    input b,
    output q
);

    // Based on the provided simulation waveforms:
    // a=0, b=0 -> q=0
    // a=0, b=1 -> q=0
    // a=1, b=0 -> q=0
    // a=1, b=1 -> q=1
    // This truth table corresponds to a logical AND operation.

    assign q = a & b;

endmodule
