module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// One-hot state encodings: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
	localparam A = 2'd0;
	localparam B = 2'd1;
	localparam C = 2'd2;
	localparam D = 2'd3;

	// Combinational next-state logic (by inspection of the one-hot table)
	// A -> A (in=0), B (in=1)
	// B -> C (in=0), B (in=1)
	// C -> A (in=0), D (in=1)
	// D -> C (in=0), B (in=1)
	always @(*) begin
		next_state[A] = ~in & (state[A] | state[C]);
		next_state[B] =  in & (state[A] | state[B] | state[D]);
		next_state[C] = ~in & (state[B] | state[D]);
		next_state[D] =  in & state[C];
	end

	// Moore output: out = 1 only in state D (driven continuously, out is a wire)
	assign out = state[D];

endmodule
