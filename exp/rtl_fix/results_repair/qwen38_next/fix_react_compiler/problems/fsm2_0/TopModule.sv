module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

	reg state;
	reg next_state;

	localparam OFF = 1'b0;
	localparam ON  = 1'b1;

	// State register with asynchronous active-high reset
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= OFF;
		end else begin
			state <= next_state;
		end
	end

	// Next-state logic
	always @(*) begin
		case (state)
			OFF: begin
				if (j) begin
					next_state = ON;
				end else begin
					next_state = OFF;
				end
			end
			ON: begin
				if (k) begin
					next_state = OFF;
				end else begin
					next_state = ON;
				end
			end
			default: next_state = OFF;
		endcase
	end

	// Moore output
	assign out = state;

endmodule
