module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

	reg [1:0] state, next_state;

	// State encodings (were undeclared in the original code)
	localparam [1:0] S   = 2'd0;  // nothing matched
	localparam [1:0] S1  = 2'd1;  // saw "1"
	localparam [1:0] S10 = 2'd2;  // saw "10"

	// State register: negative-edge asynchronous reset
	always @(posedge clk or negedge aresetn) begin
		if (!aresetn) begin
			state <= S;
		end else begin
			state <= next_state;
		end
	end

	// Next-state and Mealy output logic
	always @(*) begin
		case (state)
			S: begin
				if (x == 1'b1)
					next_state = S1;
				else
					next_state = S;
				z = 1'b0;
			end
			S1: begin
				if (x == 1'b1)
					next_state = S1;   // keep the trailing "1"
				else
					next_state = S10;
				z = 1'b0;
			end
			S10: begin
				if (x == 1'b1)
					next_state = S1;   // "101" detected, overlap keeps the "1"
				else
					next_state = S;
				z = x;                 // assert z on the "1" of "101"
			end
			default: begin
				next_state = S;
				z = 1'b0;
			end
		endcase
	end

endmodule
