module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

// State | Next state in=0, Next state in=1 | Output
// A | A, B | 0
// B | C, B | 0
// C | A, D | 0
// D | C, B | 1

// One-hot encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
// A is index 0, B is index 1, C is index 2, D is index 3

// Deriving next_state logic:
// next_state[0] (A) = (state[0] & ~in) | (state[2] & ~in)
// next_state[1] (B) = (state[0] & in) | (state[1] & in) | (state[3] & in)
// next_state[2] (C) = (state[1] & ~in) | (state[3] & ~in)
// next_state[3] (D) = (state[2] & in)

// Deriving output logic:
// out = state[3] (D)

always @(*) begin
    next_state[0] = (state[0] & ~in) | (state[2] & ~in);
    next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
    next_state[2] = (state[1] & ~in) | (state[3] & ~in);
    next_state[3] = (state[2] & in);
end

assign out = state[3];

endmodule
