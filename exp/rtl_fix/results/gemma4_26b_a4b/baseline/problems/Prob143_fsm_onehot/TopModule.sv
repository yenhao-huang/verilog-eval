module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    // The module implements the combinational logic for the state transitions 
    // and the outputs of the provided state machine.
    // The state is represented using one-hot encoding where state[i] corresponds to state Si.
    // Since the input state can be a combination of multiple states, 
    // we use OR logic to determine the next state.

    always @(*) begin
        // --- next_state logic ---
        
        // S0 transitions:
        // S0, S1, S2, S3, S4, S7, S8, S9 --0--> S0
        // S5 --0--> S8, S6 --0--> S9
        next_state[0] = (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & ~in;

        // S1 transitions:
        // S0, S8, S9 --1--> S1
        // S1 --1--> S2, S2 --1--> S3, S3 --1--> S4, S4 --1--> S5, S5 --1--> S6, S6 --1--> S7, S7 --1--> S7
        next_state[1] = (state[0] | state[8] | state[9]) & in;

        // S2 transitions:
        // S1 --1--> S2
        next_state[2] = state[1] & in;

        // S3 transitions:
        // S2 --1--> S3
        next_state[3] = state[2] & in;

        // S4 transitions:
        // S3 --1--> S4
        next_state[4] = state[3] & in;

        // S5 transitions:
        // S4 --1--> S5
        next_state[5] = state[4] & in;

        // S6 transitions:
        // S5 --1--> S6
        next_state[6] = state[5] & in;

        // S7 transitions:
        // S6, S7 --1--> S7
        next_state[7] = (state[6] | state[7]) & in;

        // S8 transitions:
        // S5 --0--> S8
        next_state[8] = state[5] & ~in;

        // S9 transitions:
        // S6 --0--> S9
        next_state[9] = state[6] & ~in;

        // --- output logic ---
        // S7: (0, 1)
        // S8: (1, 0)
        // S9: (1, 1)
        // All other states: (0, 0)
        
        out1 = state[8] | state[9];
        out2 = state[7] | state[9];
    end

endmodule
