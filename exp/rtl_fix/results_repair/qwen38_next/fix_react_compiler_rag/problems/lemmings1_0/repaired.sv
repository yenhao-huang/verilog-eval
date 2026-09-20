module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	parameter WL = 2'b00;
	parameter WR = 2'b01;

	reg [1:0] state;

	// State register with asynchronous active-high reset
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WL;
		end else begin
			case (state)
				WL: begin
					if (bump_left)
						state <= WR;   // bumped on left (or both) -> walk right
					else
						state <= WL;
				end
				WR: begin
					if (bump_right)
						state <= WL;   // bumped on right (or both) -> walk left
					else
						state <= WR;
				end
				default: state <= WL;
			endcase
		end
	end

	// Moore outputs: continuous assignment to the wire outputs
	assign walk_left  = (state == WL);
	assign walk_right = (state == WR);

endmodule
