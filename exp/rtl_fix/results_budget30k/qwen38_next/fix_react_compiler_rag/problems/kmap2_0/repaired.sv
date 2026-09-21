module top_module (
	input a, 
	input b,
	input c,
	input d,
	output out
);

	// Combinational logic from the Karnaugh map:
	//  - (~c & ~b)  : group covering minterms 0,1,8,9
	//  - (~d & ~a)  : group covering minterms 0,2,4,6
	//  - (a & c & d): group covering minterms 11,15
	//  - (b & c & d): group covering minterms 7,15
	assign out = (~c & ~b) | (~d & ~a) | (a & c & d) | (b & c & d);

endmodule
