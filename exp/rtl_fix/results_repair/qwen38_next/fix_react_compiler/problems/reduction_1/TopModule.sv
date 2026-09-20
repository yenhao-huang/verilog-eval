module top_module (
	input [7:0] in,
	output parity
);

  // Even parity: XOR-reduction of all 8 data bits.
  // Continuous assignment is required because 'parity' is a wire (net).
  assign parity = ^in;

endmodule
