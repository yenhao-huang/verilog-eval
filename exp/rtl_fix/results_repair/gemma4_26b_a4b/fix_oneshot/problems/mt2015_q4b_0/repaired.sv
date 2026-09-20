module top_module(
	input x,
	input y,
	output z);

	// The waveform shows that z is the XNOR of x and y.
	// (x,y) = (0,0) -> z=1
	// (x,y) = (1,0) -> z=0
	// (x,y) = (0,1) -> z=0
	// (x,y) = (1,1) -> z=1
	// The changes in z occur at the same time as changes in x or y, 
	// indicating combinational logic.
	assign z = ~(x ^ y);

endmodule
