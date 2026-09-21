module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    // Priority encoder: report index of lowest-numbered set bit.
    // If no bits are high, output 0.
    assign pos = in[0] ? 2'd0 :
                 in[1] ? 2'd1 :
                 in[2] ? 2'd2 :
                 in[3] ? 2'd3 :
                         2'd0;

endmodule
