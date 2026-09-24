module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // K-map simplification (d treated as don't-care):
    //   Group 1: a = 1 (covers ab=10, ab=11 for all cd, using don't-cares)
    //   Group 2: c = 1 and b = 0 (covers ab=00 for cd=11, cd=10)
    assign out = a | (c & ~b);

endmodule
