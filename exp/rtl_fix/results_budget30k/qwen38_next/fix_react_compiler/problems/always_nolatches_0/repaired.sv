module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);

	// Combinational decode of the last two scancode bytes.
	// No clock exists in this module, so use always @* (not posedge clk).
	// Default all outputs to 0 first so no latches are inferred.
	always @* begin
		left  = 1'b0;
		down  = 1'b0;
		right = 1'b0;
		up    = 1'b0;

		case (scancode)
			16'he06b: left  = 1'b1;   // left arrow
			16'he072: down  = 1'b1;   // down arrow
			16'he074: right = 1'b1;   // right arrow
			16'he075: up    = 1'b1;   // up arrow
			default: ;                // anything else -> none (all zero)
		endcase
	end

endmodule
