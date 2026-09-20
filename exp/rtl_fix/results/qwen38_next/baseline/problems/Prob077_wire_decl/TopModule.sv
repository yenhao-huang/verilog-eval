module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    wire ab_out;
    wire cd_out;

    assign ab_out = a & b;
    assign cd_out = c & d;

    assign out    = ab_out | cd_out;
    assign out_n  = ~out;

endmodule
