module top_module(
	input a, 
	input b,
	output out
);

// XNOR: output is high when both inputs are equal
assign out = ~(a ^ b);

endmodule
