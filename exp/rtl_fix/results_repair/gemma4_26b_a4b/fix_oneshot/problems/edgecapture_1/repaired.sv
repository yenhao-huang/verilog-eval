module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

reg [31:0] d_last;

always @(posedge clk)
begin
	if (reset) begin
		out <= 32'b0;
		d_last <= 32'b0;
	end
	else begin
		d_last <= in;
		// A 1-to-0 transition is detected when the previous value (d_last) was 1 
		// and the current value (~in) is 0.
		out <= out | (d_last & ~in);
	end
end

endmodule
