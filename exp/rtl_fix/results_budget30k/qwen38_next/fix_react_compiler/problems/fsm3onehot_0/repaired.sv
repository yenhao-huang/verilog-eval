module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	localparam A = 0;
	localparam B = 1;
	localparam C = 2;
	localparam D = 3;

	// Combinational next-state logic (one-hot, by inspection)
	always @(*) begin
		next_state[A] = (~in) & (state[A] | state[C]);   // A->A (in=0), C->A (in=0)
		next_state[B] =   in  & (state[A] | state[B] | state[D]); // A->B, B->B, D->B (in=1)
		next_state[C] = (~in) & (state[B] | state[D]);   // B->C (in=0), D->C (in=0)
		next_state[D] =   in  & (state[C]);              // C->D (in=1)
	end

	// Moore output
	assign out = state[D];

endmodule
