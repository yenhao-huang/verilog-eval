module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Truth table from the waveforms shows q = 1 whenever an even number
    // of the inputs are 1  =>  q is the 4-input XNOR (even-parity) function.
    assign q = ~(a ^ b ^ c ^ d);

endmodule
