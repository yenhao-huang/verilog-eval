module top_module (
	input [3:0] in,
	output reg [1:0] pos
);

	// Combinational priority encoder: output index of the first (lowest) set bit.
	// If no bit is set, output 0.
	always @(*) begin
		if (in[0])
			pos = 2'd0;
		else if (in[1])
			pos = 2'd1;
		else if (in[2])
			pos = 2'd2;
		else if (in[3])
			pos = 2'd3;
		else
			pos = 2'd0;   // in == 4'b0000
	end

endmodule
