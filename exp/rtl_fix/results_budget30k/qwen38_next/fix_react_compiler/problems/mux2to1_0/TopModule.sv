module top_module (
	input a,
	input b,
	input sel,
	output out
);

	// 2-to-1 multiplexer: combinational logic, no clock needed.
	// sel = 0 -> out = a, sel = 1 -> out = b
	assign out = sel ? b : a;

endmodule
