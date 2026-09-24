module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

	// State encoding: these declarations were missing in the original code
	localparam [1:0] S   = 2'd0;  // nothing matched
	localparam [1:0] S1  = 2'd1;  // got "1"
	localparam [1:0] S10 = 2'd2;  // got "10"

	reg [1:0] state, next_state;   // 2 bits are needed for 3 states

	// State register: negative-edge asynchronous reset
	always @(posedge clk or negedge aresetn) begin
		if (!aresetn)
			state <= S;
		else
			state <= next_state;
	end

	// Next-state and Mealy output logic (blocking assignments)
	always @(*) begin
		case (state)
			S: begin
				if (x)
					next_state = S1;
				else
					next_state = S;
				z = 1'b0;
			end

			S1: begin
				if (!x)
					next_state = S10;
				else
					next_state = S1;   // stay on overlapping "1"
				z = 1'b0;
			end

			S10: begin
				if (!x)
					next_state = S;
				else
					next_state = S1;   // "101" detected, overlap handled
				z = x;                 // z = 1 when the final "1" arrives
			end

			default: begin
				next_state = S;
				z = 1'b0;
			end
		endcase
	end

endmodule
