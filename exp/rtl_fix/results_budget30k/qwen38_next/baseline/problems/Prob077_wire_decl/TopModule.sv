module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    wire ab;
    wire cd;

    and (ab, a, b);
    and (cd, c, d);
    or  (out, ab, cd);
    not (out_n, out);

endmodule
