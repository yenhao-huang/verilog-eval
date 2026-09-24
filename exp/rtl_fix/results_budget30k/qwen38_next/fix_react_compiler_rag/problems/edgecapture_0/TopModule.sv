module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

	// History register: value of "in" on the previous clock cycle
	reg [31:0] d_last;

	always @(posedge clk) begin
		d_last <= in;
	end

	always @(posedge clk) begin
		if (reset) begin
			out <= 0;
		end
		else begin
			// Capture bits that changed from 1 (previous cycle) to 0 (this cycle)
			out <= out | (~in & d_last);
		end
	end

endmodule
