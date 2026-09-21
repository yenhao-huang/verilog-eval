module top_module (
	input a, 
	input b,
	input c,
	input d,
	output out
);

// Combinational logic from the Karnaugh map (wire output -> use assign)
assign out = (~c & ~b) | (~d & ~a) | (a & c & d) | (b & c & d);

endmodule
