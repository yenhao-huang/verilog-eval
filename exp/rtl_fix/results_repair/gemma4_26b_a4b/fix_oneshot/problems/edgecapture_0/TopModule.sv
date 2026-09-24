module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

	// d_last stores the value of 'in' from the previous clock cycle
	reg [31:0] d_last;

	always @(posedge clk) begin
		if (reset) begin
			// Synchronous reset: clear both the capture register and the history register
			out <= 32'b0;
			d_last <= 32'b0;
		end
		else begin
			// A transition from 1 to 0 is detected when d_last is 1 and current in is 0
			// The output 'out' uses a bitwise OR to "capture" (sticky bit behavior)
			out <= out | (d_last & ~in);
			
			// Update the history register for the next clock cycle
			d_last <= in;
		end
	end

endmodule
