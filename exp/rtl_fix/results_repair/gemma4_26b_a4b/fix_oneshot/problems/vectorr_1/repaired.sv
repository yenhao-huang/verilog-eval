module top_module (
	input [7:0] in,
	output [7:0] out
);

	// The bit reversal can be implemented using a continuous assignment 
	// with bit concatenation. This is a combinational logic implementation.
	assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
