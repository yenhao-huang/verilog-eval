module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

reg state;
reg next_state;

	// State register with asynchronous active-high reset
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= 1'b0;
		end else begin
			state <= next_state;
		end
	end

	// Next state logic
	always @(*) begin
		case (state)
			1'b0: begin
				if (j) begin
					next_state = 1'b1;
				end else begin
					next_state = 1'b0;
				end
			end
			1'b1: begin
				if (k) begin
					next_state = 1'b0;
				end else begin
					next_state = 1'b1;
				end
			end
			default: next_state = 1'b0;
		endcase
	end

	// Output logic (Moore machine: output depends only on current state)
	assign out = state;

endmodule
