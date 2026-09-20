module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // (1) out_both: Each bit indicates whether the corresponding input bit 
    // and its neighbour to the left (higher index) are '1'.
    // out_both[2] = in[2] & in[3]
    // out_both[3] has no neighbour to the left, so we set it to 0.
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0;

    // (2) out_any: Each bit indicates whether any of the corresponding 
    // input bit and its neighbour to the right are '1'.
    // out_any[2] = in[2] | in[1]
    // out_any[0] has no neighbour to the right, so we set it to 0.
    assign out_any[0] = 1'b0;
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // (3) out_different: Each bit indicates whether the corresponding 
    // input bit is different from its neighbour to the left.
    // Treat the vector as wrapping around, so in[3]'s neighbour to the left is in[0].
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule
