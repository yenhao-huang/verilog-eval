module top_module (
	input [31:0] in,
	output [31:0] out
);

	// Reverse the byte order: out[7:0]  = in[31:24]
	//                       out[15:8]  = in[23:16]
	//                       out[23:16] = in[15:8]
	//                       out[31:24] = in[7:0]
	assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule
