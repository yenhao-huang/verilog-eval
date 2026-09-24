module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // From the waveform, q is 0 only when b = 0 and c = 0.
    // Therefore, q = b OR c. Inputs a and d do not affect q.
    assign q = b | c;

endmodule
