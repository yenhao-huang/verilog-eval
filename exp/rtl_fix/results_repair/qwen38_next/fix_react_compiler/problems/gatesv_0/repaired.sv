module top_module (
	input [3:0] in,
	output [2:0] out_both,
	output [3:1] out_any,
	output [3:0] out_different
);

    // both the bit and its left (higher-index) neighbour are 1
    assign out_both = in[2:0] & in[3:1];          // out_both[i] = in[i] & in[i+1]

    // either the bit or its right (lower-index) neighbour is 1
    assign out_any  = in[3:1] | in[2:0];          // out_any[i]  = in[i] | in[i-1]

    // bit differs from left neighbour, vector wraps around (in[3] vs in[0])
    assign out_different = in ^ {in[0], in[3:1]}; // out_different[i] = in[i] ^ in[i+1 (mod 4)]

endmodule
