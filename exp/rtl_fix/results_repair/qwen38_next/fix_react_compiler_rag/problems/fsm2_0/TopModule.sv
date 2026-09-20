module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

	reg state;
	reg next_state;   // <-- missing declaration that caused the elaboration errors

	// State register with asynchronous active-high reset to OFF
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= 1'b0;
		end else begin
			state <= next_state;
		end
	end

	// Next-state logic: OFF = 1'b0 (out=0), ON = 1'b1 (out=1)
	always @(*) begin
		case (state)
			1'b0: begin                 // OFF: j=1 -> ON, j=0 -> OFF
				if (j) begin
					next_state = 1'b1;
				end else begin
					next_state = 1'b0;
				end
			end
			1'b1: begin                 // ON: k=1 -> OFF, k=0 -> ON
				if (k) begin
					next_state = 1'b0;
				end else begin
					next_state = 1'b1;
				end
			end
			default: next_state = 1'b0;
		endcase
	end

	// Moore output: depends only on the state
	assign out = state;

endmodule
