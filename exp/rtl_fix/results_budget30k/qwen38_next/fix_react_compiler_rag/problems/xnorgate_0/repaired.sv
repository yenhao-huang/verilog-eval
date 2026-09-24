module top_module(
	input a, 
	input b,
	output out
);

// XNOR: out is high when a and b are equal
assign out = ~(a ^ b);   // equivalent: assign out = a ~^ b;  or  assign out = (a == b);

endmodule
