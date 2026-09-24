module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);

	// Purely combinational decode: no clock exists in this module's ports,
	// so use always @(*) with blocking assignments and default values
	// so that no latches are inferred.
	always @(*) begin
		left  = 1'b0;
		down  = 1'b0;
		right = 1'b0;
		up    = 1'b0;

		case (scancode)
			16'he06b: left  = 1'b1;   // left arrow
			16'he072: down  = 1'b1;   // down arrow
			16'he074: right = 1'b1;   // right arrow
			16'he075: up    = 1'b1;   // up arrow
			default: begin            // anything else -> none asserted
			end
		endcase
	end

endmodule
