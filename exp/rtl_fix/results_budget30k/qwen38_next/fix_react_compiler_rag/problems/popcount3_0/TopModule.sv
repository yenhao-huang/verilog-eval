module top_module (
	input [2:0] in,
	output [1:0] out
);

    // Population count: sum of the three input bits (0..3, fits in 2 bits)
    assign out = in[2] + in[1] + in[0];

endmodule
