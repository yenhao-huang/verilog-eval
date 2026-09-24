module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // K-map simplification (d entries treated as don't-cares):
    //   group 1: a = 1 (covers ab = 10, 11 for cd = 00, 11, 10 and don't-cares at cd = 01)
    //   group 2: ~b & c (covers ab = 00, 10 for cd = 11, 10)
    assign out = a | (~b & c);

endmodule
