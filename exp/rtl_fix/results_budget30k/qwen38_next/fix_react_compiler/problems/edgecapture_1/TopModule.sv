module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

	// previous value of in, used to detect 1 -> 0 transitions
	reg [31:0] d_last = 32'b0;

	always @(posedge clk) begin
		if (reset) begin
			out <= 32'b0;
		end else begin
			// capture (sticky) bits that fell from 1 to 0
			out <= out | (~in & d_last);
		end
		// remember current input for next cycle's edge detection
		d_last <= in;
	end

endmodule
