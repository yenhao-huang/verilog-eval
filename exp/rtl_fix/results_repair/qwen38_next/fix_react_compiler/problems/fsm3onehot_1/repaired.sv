module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// One-hot state encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
	// Declare the state names as bit positions so they can be used as
	// constant bit-select indices.
	localparam A = 0;
	localparam B = 1;
	localparam C = 2;
	localparam D = 3;

	// Next-state logic
	assign next_state[A] = ~in & (state[A] | state[C]);              // in=0: A->A, C->A
	assign next_state[B] =  in & (state[A] | state[B] | state[D]);   // in=1: A->B, B->B, D->B
	assign next_state[C] = ~in & (state[B] | state[D]);              // in=0: B->C, D->C
	assign next_state[D] =  in & state[C];                           // in=1: C->D

	// Output logic (Moore)
	assign out = state[D];

endmodule
