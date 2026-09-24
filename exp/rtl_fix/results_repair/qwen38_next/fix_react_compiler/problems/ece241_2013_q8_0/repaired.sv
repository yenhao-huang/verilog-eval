module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

	// ---- FIX 1: declare the state names (they were undeclared -> "unable to bind") ----
	// ---- FIX 2: 3 states require 2-bit encoding, not 1-bit ----
	localparam S   = 2'd0;  // idle: nothing of "101" seen
	localparam S1  = 2'd1;  // saw "1"
	localparam S10 = 2'd2;  // saw "10"

	reg [1:0] state, next_state;

	// State register: negative-edge asynchronous active-low reset
	always @(posedge clk or negedge aresetn) begin
		if (~aresetn)
			state <= S;
		else
			state <= next_state;
	end

	// Combinational next-state + Mealy output (blocking assignments)
	always @(state or x) begin
		case (state)
			S: begin
				if (x == 1'b0) next_state = S;
				else           next_state = S1;
				z = 1'b0;
			end
			S1: begin
				if (x == 1'b0) next_state = S10;
				else           next_state = S1;
				z = 1'b0;
			end
			S10: begin
				if (x == 1'b0) next_state = S;
				else           next_state = S1;  // overlapping: this '1' starts a new "101"
				z = x;                           // "101" detected -> z = 1
			end
			default: begin
				next_state = S;
				z = 1'b0;
			end
		endcase
	end

endmodule
