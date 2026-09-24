module top_module(
	input in,
	output out);

	// Behaves exactly like a wire: out always follows in
	assign out = in;

endmodule
