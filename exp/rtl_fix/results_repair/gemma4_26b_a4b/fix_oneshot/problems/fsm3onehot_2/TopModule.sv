module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

/*
State Transition Table:
State | Next state in=0 | Next state in=1 | Output
A (0001) | A (0001)     | B (0010)        | 0
B (0010) | C (0100)     | B (0010)        | 0
C (0100) | A (0001)     | D (1000)        | 0
D (1000) | C (0100)     | B (0010)        | 1

One-hot Encoding:
A: state[0]
B: state[1]
C: state[2]
D: state[3]

Deriving next_state logic:
next_state[0] (A) = (state[0] & ~in) | (state[2] & ~in)
next_state[1] (B) = (state[0] & in)  | (state[1] & in)  | (state[3] & in)
next_state[2] (C) = (state[1] & ~in) | (state[3] & ~in)
next_state[3] (D) = (state[2] & in)

Deriving output logic:
out = state[3]
*/

always @(*) begin
    next_state[0] = (~in & state[0]) | (~in & state[2]);
    next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]);
    next_state[2] = (~in & state[1]) | (~in & state[3]);
    next_state[3] = (in & state[2]);
end

assign out = state[3];

endmodule
