module top_module(
	input a, 
	input b,
	output out
);

// Built-in gate primitives use positional (not named) port connections:
//   <gate_primitive> [delay] <output>, <input>, ...
xnor out_gate(out, a, b);

// Equivalent behavioral form: assign out = ~(a ^ b);

endmodule
