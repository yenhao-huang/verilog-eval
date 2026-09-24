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

	// Sequential (state) logic with asynchronous active-high reset
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WL;
		end else begin
			case (state)
				WL: begin
					if (bump_left)
						state <= WR;   // bumped left  -> walk right
					else
						state <= WL;
				end
				WR: begin
					if (bump_right)
						state <= WL;   // bumped right -> walk left
					else
						state <= WR;
				end
				default: state <= WL;
			endcase
		end
	end

	// Moore outputs: driven as continuous assignments (nets), not procedural l-values
	assign walk_left  = (state == WL);
	assign walk_right = (state == WR);

endmodule
