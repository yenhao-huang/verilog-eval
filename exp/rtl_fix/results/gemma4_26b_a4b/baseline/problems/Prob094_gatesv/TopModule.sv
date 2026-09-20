module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // (1) out_both: Each bit indicates if the input bit and its neighbor 
    // to the left (higher index) are both '1'.
    // in[3] has no neighbor to the left, so out_both[3] is set to 0.
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0;

    // (2) out_any: Each bit indicates if the input bit or its neighbor 
    // to the right (lower index) are '1'.
    // in[0] has no neighbor to the right, so out_any[0] is set to 0.
    assign out_any[0] = 1'b0;
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // (3) out_different: Each bit indicates if the input bit is different 
    // from its neighbor to the left (higher index), with wrap-around.
    // in[3]'s neighbor to the left is in[0].
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule
