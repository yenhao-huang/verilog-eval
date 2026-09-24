module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	// ---- State encoding (was missing) ----
	parameter A = 2'b00;
	parameter B = 2'b01;
	parameter C = 2'b10;
	parameter D = 2'b11;

	// ---- State register (was missing) ----
	reg [1:0] state;

	// ---- Next-state logic + synchronous active-high reset ----
	always @(posedge clk) begin
		if (reset) begin
			state <= A;
		end
		else begin
			case (state)
				A: begin
					if (in) state <= B;
					else    state <= A;   // this branch was missing
				end
				B: begin
					if (in) state <= B;
					else    state <= C;
				end
				C: begin
					if (in) state <= D;
					else    state <= A;
				end
				D: begin
					if (in) state <= B;
					else    state <= C;
				end
				default: state <= A;
			endcase
		end
	end

	// ---- Moore output: high only in state D ----
	assign out = (state == D);

endmodule
