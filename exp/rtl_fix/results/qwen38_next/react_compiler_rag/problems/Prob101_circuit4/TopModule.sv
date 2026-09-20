module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // From the waveform: q = 1 whenever b = 1 or c = 1.
    // Inputs a and d never affect q.
    assign q = b | c;

endmodule
