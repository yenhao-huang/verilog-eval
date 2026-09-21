module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // K-map groups:
    //   1) ~b & ~c      -> cells (cd=00, ab=00/10) and (cd=01, ab=00/10)
    //   2) ~a & ~d      -> cells (cd=00, ab=00/01), (cd=10, ab=00/01)
    //   3) c & d & (a|b)-> cells (cd=11, ab=01/11/10)
    assign out = (~b & ~c) | (~a & ~d) | (c & d & (a | b));

endmodule
