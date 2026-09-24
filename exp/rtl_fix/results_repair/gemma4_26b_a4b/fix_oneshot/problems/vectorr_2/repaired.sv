module top_module (
	input [7:0] in,
	output [7:0] out
);

  // The streaming operator {<<{in}} reverses the order of elements in the bit-stream.
  // Since 'in' is a bit-vector, it reverses the bit order.
  assign out = {<<{in}};

endmodule
