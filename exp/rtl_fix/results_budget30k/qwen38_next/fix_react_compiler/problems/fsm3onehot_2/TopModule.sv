module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// One-hot state bit indices: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
	localparam integer A = 0;
	localparam integer B = 1;
	localparam integer C = 2;
	localparam integer D = 3;

	// Purely combinational logic (no clock in this module)
	always @(*) begin
		// A is reached from A (in=0) and C (in=0)
		next_state[A] = !in & (state[A] | state[C]);
		// B is reached from A (in=1), B (in=1), D (in=1)
		next_state[B] =  in & (state[A] | state[B] | state[D]);
		// C is reached from B (in=0) and D (in=0)
		next_state[C] = !in & (state[B] | state[D]);
		// D is reached from C (in=1)
		next_state[D] =  in & state[C];
	end

	// Moore output: asserted only in state D
	assign out = state[D];

endmodule
