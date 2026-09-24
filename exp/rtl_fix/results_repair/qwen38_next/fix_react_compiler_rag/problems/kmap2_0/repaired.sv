module top_module (
	input a, 
	input b,
	input c,
	input d,
	output out
);

	// Combinational logic from the K-map: continuous assignment
	// (a wire output cannot be driven from an always block, and no clk exists)
	assign out = (~c & ~b) | (~d & ~a) | (a & c & d) | (b & c & d);

endmodule
