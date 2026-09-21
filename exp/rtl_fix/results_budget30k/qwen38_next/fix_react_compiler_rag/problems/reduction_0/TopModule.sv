module top_module (
	input [7:0] in,
	output parity
);

	// Even parity: XOR reduction of all 8 data bits (combinational, no clk needed)
	assign parity = ^in;

endmodule
