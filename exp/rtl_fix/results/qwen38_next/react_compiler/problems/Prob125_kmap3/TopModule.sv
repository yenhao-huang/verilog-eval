module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map grouping:
    //   - all cells with a=1 (columns ab=10, ab=11) -> term "a"
    //   - cells with c=1 and b=0 (ab=00 rows cd=11,10 plus ab=10 covered above) -> term "c & ~b"
    //   - don't-cares (d) are absorbed by these groups
    assign out = a | (c & ~b);

endmodule
