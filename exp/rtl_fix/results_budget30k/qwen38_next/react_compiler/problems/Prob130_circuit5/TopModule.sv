module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Combinational lookup based on selector c:
    //   c == 0 -> b
    //   c == 1 -> e
    //   c == 2 -> a
    //   c == 3 -> d
    //   c >= 4 -> 4'hf
    assign q = (c == 4'd0) ? b :
               (c == 4'd1) ? e :
               (c == 4'd2) ? a :
               (c == 4'd3) ? d :
                             4'hf;

endmodule
