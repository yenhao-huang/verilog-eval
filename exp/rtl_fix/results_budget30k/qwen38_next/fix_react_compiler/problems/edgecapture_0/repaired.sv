module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

	reg [31:0] d_last;

	always @(posedge clk) begin
		d_last <= in;
		if (reset) begin
			out <= 0;
		end
		else begin
			out <= out | (d_last & ~in);
		end
	end

endmodule
