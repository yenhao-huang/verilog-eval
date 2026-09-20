module top_module (
	input [99:0] a,
	input [99:0] b,
	input sel,
	output [99:0] out
);

	// A 2-1 multiplexer is a combinational circuit.
	// The erroneous implementation attempted to use a clock (clk) that was not defined 
	// and tried to assign values to a 'wire' inside an 'always' block.
	// The correct way to implement a combinational mux is using an 'assign' statement.
	assign out = sel ? b : a;

endmodule
