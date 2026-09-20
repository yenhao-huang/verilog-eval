module top_module (
	input [7:0] in,
	output [31:0] out
);

// To sign-extend, we need to replicate the sign bit (in[7]) 24 times.
// The replication operator syntax is {multiplier{expression}}.
// When using the replication operator as part of a concatenation, 
// it must be enclosed in its own set of braces: { {multiplier{expression}}, other_elements }.
assign out = { {24{in[7]}}, in };

endmodule
