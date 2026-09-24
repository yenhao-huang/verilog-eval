module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// The problem asks for the combinational logic portion of the Moore state machine.
	// Using one-hot encoding: A=4'b0001 (index 0), B=4'b0010 (index 1), C=4'b0100 (index 2), D=4'b1000 (index 3).
	
	// State Transition Logic:
	// A: in=0 -> A, in=1 -> B
	// B: in=0 -> C, in=1 -> B
	// C: in=0 -> A, in=1 -> D
	// D: in=0 -> C, in=1 -> B
	
	always @(*) begin
		// next_state[0] (A) is 1 if (state is A and in=0) or (state is C and in=0)
		next_state[0] = !in & (state[0] | state[2]);
		
		// next_state[1] (B) is 1 if (state is A and in=1) or (state is B and in=1) or (state is D and in=1)
		next_state[1] = in & (state[0] | state[1] | state[3]);
		
		// next_state[2] (C) is 1 if (state is B and in=0) or (state is D and in=0)
		next_state[2] = !in & (state[1] | state[3]);
		
		// next_state[3] (D) is 1 if (state is C and in=1)
		next_state[3] = in & state[2];
	end

	// Output Logic:
	// Output is 1 only when in state D.
	assign out = state[3];

endmodule
