module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

reg state;
reg next_state;

// Sequential block for state transition with asynchronous reset
always @(posedge clk or posedge areset) begin
	if (areset) begin
		state <= 1'b0;
	end else begin
		state <= next_state;
	end
end

// Combinational block for next state logic
always @(*) begin
	case (state)
		1'b0: begin // OFF state
			if (j) begin
				next_state = 1'b1;
			end else begin
				next_state = 1'b0;
			end
		end
		1'b1: begin // ON state
			if (k) begin
				next_state = 1'b0;
			end else begin
				next_state = 1'b1;
			end
		end
		default: begin
			next_state = 1'b0;
		end
	endcase
end

// Moore output depends only on the current state
assign out = state;

endmodule
