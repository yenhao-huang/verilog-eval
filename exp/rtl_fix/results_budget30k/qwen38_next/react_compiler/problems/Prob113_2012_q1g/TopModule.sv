module TopModule (
    input  [3:0] x,
    output       f
);

    // K-map groups:
    //   ~x[3] & ~x[1]        -> minterms 0,1,4,5
    //    x[2]  & ~x[0]       -> minterms 4,6,12,14
    //    x[2]  &  x[3] & x[1]-> minterms 14,15
    assign f = (~x[3] & ~x[1]) |
               ( x[2] & ~x[0]) |
               ( x[2] &  x[3] & x[1]);

endmodule
