module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    /*
    State Encoding (One-Hot):
    A = 4'b0001 (state[0])
    B = 4'b0010 (state[1])
    C = 4'b0100 (state[2])
    D = 4'b1000 (state[3])

    State Transition Table:
    State | Next state (in=0) | Next state (in=1) | Output
    ------------------------------------------------------
    A     | A (0001)          | B (0010)          | 0
    B     | C (0100)          | B (0010)          | 0
    C     | A (0001)          | D (1000)          | 0
    D     | C (0100)          | B (0010)          | 1

    Deriving Logic Equations:
    
    Next State A (next_state[0]):
    A is the next state if (Current state is A AND in=0) OR (Current state is C AND in=0).
    next_state[0] = (state[0] & ~in) | (state[2] & ~in)
                  = (state[0] | state[2]) & ~in;

    Next State B (next_state[1]):
    B is the next state if (Current state is A AND in=1) OR (Current state is B AND in=1) OR (Current state is D AND in=1).
    next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in)
                  = (state[0] | state[1] | state[3]) & in;

    Next State C (next_state[2]):
    C is the next state if (Current state is B AND in=0) OR (Current state is D AND in=0).
    next_state[2] = (state[1] & ~in) | (state[3] & ~in)
                  = (state[1] | state[3]) & ~in;

    Next State D (next_state[3]):
    D is the next state if (Current state is C AND in=1).
    next_state[3] = state[2] & in;

    Output Logic:
    Output is 1 only when in state D.
    out = state[3];
    */

    assign next_state[0] = (state[0] | state[2]) & ~in;
    assign next_state[1] = (state[0] | state[1] | state[3]) & in;
    assign next_state[2] = (state[1] | state[3]) & ~in;
    assign next_state[3] = state[2] & in;

    assign out = state[3];

endmodule
