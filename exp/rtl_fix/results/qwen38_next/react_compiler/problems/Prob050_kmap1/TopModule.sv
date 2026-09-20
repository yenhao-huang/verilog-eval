module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire out
);

    // K-map: out is 0 only for minterm (a=0, b=0, c=0)
    // Groups: a, b, c  =>  out = a | b | c
    assign out = a | b | c;

endmodule
