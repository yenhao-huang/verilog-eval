module top_module (
	input [31:0] in,
	output [31:0] out
);

	// Reversing the byte order of a 32-bit vector using combinational logic.
	// Byte 3 (in[31:24]) moves to Byte 0 (out[7:0])
	// Byte 2 (in[23:16]) moves to Byte 1 (out[15:8])
	// Byte 1 (in[15:8])  moves to Byte 2 (out[23:16])
	// Byte 0 (in[7:0])   moves to Byte 3 (out[31:24])
	
	assign out[7:0]   = in[31:24];
	assign out[15:8]  = in[23:16];
	assign out[23:16] = in[15:8];
	assign out[31:24] = in[7:0];

endmodule
