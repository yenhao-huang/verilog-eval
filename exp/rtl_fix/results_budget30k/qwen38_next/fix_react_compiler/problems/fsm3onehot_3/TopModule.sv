module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// one-hot state encodings: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
	localparam A = 0;
	localparam B = 1;
	localparam C = 2;
	localparam D = 3;

	// state transition logic (by inspection of the one-hot table)
	always @(*) begin
		next_state = 4'b0000;                                   // default: no latch
		next_state[A] = (!in && (state[A] || state[C]));         // A: in=0 -> A, C: in=0 -> A
		next_state[B] = ( in && (state[A] || state[B] || state[D])); // B: A(in=1), B(in=1), D(in=1)
		next_state[C] = (!in && (state[B] || state[D]));         // C: B(in=0), D(in=0)
		next_state[D] = ( in && state[C]);                       // D: C(in=1)
	end

	// Moore output: high only in state D
	assign out = state[D];

endmodule
