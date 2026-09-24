module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire out,
    output wire out_n
);

    wire w1;
    wire w2;

    and (w1, a, b);
    and (w2, c, d);
    or  (out, w1, w2);
    not (out_n, out);

endmodule
