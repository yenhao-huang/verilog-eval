module TopModule (
    input  [3:0] x,
    output       f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    assign f = (x3 & ~x1) | (x4 & x2);

endmodule
