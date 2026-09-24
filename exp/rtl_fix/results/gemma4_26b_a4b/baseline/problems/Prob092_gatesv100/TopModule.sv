module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    /*
     * (1) out_both:
     * Each bit indicates whether the corresponding input bit and its neighbor 
     * to the left are both '1'.
     * For in[i], the neighbor to the left is in[i+1].
     * Boundary condition: out_both[99] = 0.
     */
    assign out_both[99] = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    /*
     * (2) out_any:
     * Each bit indicates whether the corresponding input bit and its neighbor 
     * to the right are '1'.
     * For in[i], the neighbor to the right is in[i-1].
     * Boundary condition: out_any[0] = 0.
     */
    assign out_any[0] = 1'b0;
    assign out_any[99:1] = in[99:1] | in[98:0];

    /*
     * (3) out_different:
     * Each bit indicates whether the corresponding input bit is different 
     * from its neighbor to the left.
     * For in[i], the neighbor to the left is in[i+1], with wrap-around.
     * For in[99], the neighbor to the left is in[0].
     */
    assign out_different[99] = in[99] ^ in[0];
    assign out_different[98:0] = in[98:0] ^ in[99:1];

endmodule
