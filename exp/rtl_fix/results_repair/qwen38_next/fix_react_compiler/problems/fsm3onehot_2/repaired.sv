module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// One-hot encoding: A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000
	localparam A = 0;
	localparam B = 1;
	localparam C = 2;
	localparam D = 3;

	// Combinational next-state logic (no clock: this is only the FSM's
	// transition/output logic, not the state register)
	always @(*) begin
		next_state[A] = ~in & (state[A] | state[C]);              // A -> A (in=0), C -> A (in=0)
		next_state[B] =  in & (state[A] | state[B] | state[D]);   // A,B,D -> B (in=1)
		next_state[C] = ~in & (state[B] | state[D]);              // B -> C (in=0), D -> C (in=0)
		next_state[D] =  in & state[C];                           // C -> D (in=1)
	end

	// Moore output: depends only on the current state
	assign out = state[D];

endmodule
