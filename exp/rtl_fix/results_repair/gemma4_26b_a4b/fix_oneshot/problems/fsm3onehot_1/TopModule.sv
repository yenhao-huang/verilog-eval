module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

// One-hot encoding:
// A = 4'b0001 (index 0)
// B = 4'b0010 (index 1)
// C = 4'b0100 (index 2)
// D = 4'b1000 (index 3)

// State Transition Table:
// State | Next state in=0 | Next state in=1 | Output
// A     | A              | B               | 0
// B     | C              | B               | 0
// C     | A              | D               | 0
// D     | C              | B               | 1

always @(*) begin
    // next_state[0] (A) is 1 if:
    // (Current state is A and in=0) OR (Current state is C and in=0)
    next_state[0] = (state[0] | state[2]) & ~in;
    
    // next_state[1] (B) is 1 if:
    // (Current state is A and in=1) OR (Current state is B and in=1) OR (Current state is D and in=1)
    next_state[1] = (state[0] | state[1] | state[3]) & in;
    
    // next_state[2] (C) is 1 if:
    // (Current state is B and in=0) OR (Current state is D and in=0)
    next_state[2] = (state[1] | state[3]) & ~in;
    
    // next_state[3] (D) is 1 if:
    // (Current state is C and in=1)
    next_state[3] = state[2] & in;
end

// Output is 1 only in state D (4'b1000)
assign out = state[3];

endmodule
