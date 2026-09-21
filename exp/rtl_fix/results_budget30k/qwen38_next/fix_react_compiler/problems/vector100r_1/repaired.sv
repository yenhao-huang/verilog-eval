module top_module (
	input [99:0] in,
	output reg [99:0] out
);

	integer i;

	// Purely combinational bit reversal: out[i] = in[99-i]
	always @(*) begin
		for (i = 0; i < 100; i = i + 1) begin
			out[i] = in[99 - i];
		end
	end

endmodule
