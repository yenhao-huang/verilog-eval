module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

	reg [7:0] d_last = 8'h0;   // previous value of in (was undeclared -> syntax error)

	always @(posedge clk) begin
		pedge  <= in & ~d_last;  // set the cycle after a 0 -> 1 transition
		d_last <= in;            // remember current input for next cycle
	end

endmodule
