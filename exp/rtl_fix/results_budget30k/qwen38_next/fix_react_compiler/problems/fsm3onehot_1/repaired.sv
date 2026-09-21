module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// ---- FIX 1: declare the one-hot state names as constants ---------------
	// A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
	localparam A = 0;   // state[0]
	localparam B = 1;   // state[1]
	localparam C = 2;   // state[2]
	localparam D = 3;   // state[3]

	// ---- FIX 2: next_state is a reg -> use a combinational always block ----
	// in=0 : A->A, B->C, C->A, D->C
	// in=1 : A->B, B->B, C->D, D->B
	always @* begin
		next_state     = 4'b0000;
		next_state[A]  = (~in & state[A]) | (~in & state[C]);
		next_state[B]  = ( in & state[A]) | state[B] | state[D];
		next_state[C]  = (~in & state[B]) | (~in & state[D]);
		next_state[D]  = ( in & state[C]);
	end

	// Moore output: high only in state D
	assign out = state[D];

endmodule
