module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// One-hot state encodings: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
	// Use the bit indices of those encodings as constants for the bit selects.
	localparam A = 2'd0;
	localparam B = 2'd1;
	localparam C = 2'd2;
	localparam D = 2'd3;

	always @(*) begin
		next_state = 4'b0000;
		// next_state[A]: stay in A on in=0 (from A), go to A on in=0 from C
		next_state[A] = (~in) & (state[A] | state[C]);
		// next_state[B]: go to B on in=1 from A, stay in B on in=1, go to B on in=1 from D
		next_state[B] = in & (state[A] | state[B] | state[D]);
		// next_state[C]: go to C on in=0 from B, go to C on in=0 from D
		next_state[C] = (~in) & (state[B] | state[D]);
		// next_state[D]: go to D on in=1 from C
		next_state[D] = in & state[C];
	end

	// Moore output: only state D has output 1
	assign out = state[D];

endmodule
