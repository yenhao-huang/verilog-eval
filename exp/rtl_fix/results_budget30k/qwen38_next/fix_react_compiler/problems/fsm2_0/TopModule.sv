module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

	reg state;
	reg next_state;

	// state register with active-high asynchronous reset
	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= 1'b0;      // OFF
		else
			state <= next_state;
	end

	// next-state logic
	always @(*) begin
		case (state)
			1'b0: begin                 // OFF
				if (j) next_state = 1'b1;
				else   next_state = 1'b0;
			end
			1'b1: begin                 // ON
				if (k) next_state = 1'b0;
				else   next_state = 1'b1;
			end
			default: next_state = 1'b0;
		endcase
	end

	// Moore output
	assign out = state;

endmodule
