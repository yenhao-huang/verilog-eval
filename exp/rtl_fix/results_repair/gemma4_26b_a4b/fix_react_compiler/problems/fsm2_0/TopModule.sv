module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

reg state;
reg next_state;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= 1'b0;
		end else begin
			state <= next_state;
		end
	end

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

	assign out = state;
endmodule
