module top_module (
	input a,
	input b,
	input sel,
	output out
);

	// A multiplexer is a combinational circuit. 
	// The erroneous implementation attempted to use a clock (clk) which was not declared,
	// and attempted to assign to a wire inside an always block.
	// Using a continuous assignment (assign) is the standard way to implement a mux.
	assign out = sel ? b : a;

endmodule
