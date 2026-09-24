module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // From the waveform:
    // c == 0 -> q = b
    // c == 1 -> q = e
    // c == 2 -> q = a
    // c == 3 -> q = d
    // otherwise -> q = 4'hf
    assign q = (c == 4'h0) ? b :
               (c == 4'h1) ? e :
               (c == 4'h2) ? a :
               (c == 4'h3) ? d :
               4'hf;

endmodule
