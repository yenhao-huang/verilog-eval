module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	parameter WL = 1'b0;
	parameter WR = 1'b1;
	reg state;

	// State register: asynchronous, positive-edge-triggered reset to walk_left
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WL;
		end else begin
			case (state)
				WL: begin
					if (bump_left)            // bumped left (or both) -> walk right
						state <= WR;
				end
				WR: begin
					if (bump_right)           // bumped right (or both) -> walk left
						state <= WL;
				end
			endcase
		end
	end

	// Moore outputs: driven with continuous assignments so they may stay as wires
	assign walk_left  = (state == WL);
	assign walk_right = (state == WR);

endmodule
