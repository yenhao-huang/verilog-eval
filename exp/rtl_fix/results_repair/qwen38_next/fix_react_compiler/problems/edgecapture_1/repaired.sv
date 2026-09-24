module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

	// Previous value of in, used to detect 1 -> 0 transitions
	reg [31:0] d_last;

	always @(posedge clk)
	begin
		if (reset)
		begin
			out    <= 32'd0;
			d_last <= 32'd0;
		end
		else
		begin
			// Capture (and hold) bits that just fell from 1 to 0
			out    <= out | (~in & d_last);
			d_last <= in;
		end
	end

endmodule
