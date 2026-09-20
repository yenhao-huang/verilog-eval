module top_module(
	input a, 
	input b,
	output out
);

// NOR gate: output is high only when both inputs are low
assign out = ~(a | b);

endmodule
