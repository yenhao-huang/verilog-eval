module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

	reg [31:0] d_last;   // previous value of in

	always @(posedge clk) begin
		if (reset) begin
			out <= 32'd0;
		end
		else begin
			out <= out | (~in & d_last);  // capture 1 -> 0 transitions
		end
		d_last <= in;    // remember current value for next cycle
	end

endmodule
