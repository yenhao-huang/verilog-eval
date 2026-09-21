module top_module (
	input [7:0] in,
	output parity
);

	assign parity = ^in;   // even parity: XOR reduction of all 8 data bits

endmodule
