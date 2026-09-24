module TopModule (
    input  x,
    input  y,
    output z
);

    // Module A: z = (x^y) & x
    wire a = (x ^ y) & x;

    // Module B: from waveform -> XNOR
    wire b = ~(x ^ y);

    // OR of first A,B pair ; AND of second A,B pair ; then XOR
    assign z = (a | b) ^ (a & b);

endmodule
