module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge);

	// Declare d_last to store the previous state of the input signal
	reg [7:0] d_last;

	always @(posedge clk) begin
		// Store the current input to be used as the 'previous' value in the next cycle
		d_last <= in;
		// Detect any edge (0 to 1 or 1 to 0) by XORing the current input with the previous input
		// The non-blocking assignment ensures anyedge is updated with the result of the 
		// transition that occurred in the previous cycle.
		anyedge <= in ^ d_last;
	end

endmodule
