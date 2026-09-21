module top_module(
	input a, 
	input b,
	output out
);

// NOR gate: out is high only when both inputs are low.
// Replaces the invalid instantiations of the undefined
// 'or_gate' and 'inverter' modules.
assign out = ~(a | b);

endmodule
