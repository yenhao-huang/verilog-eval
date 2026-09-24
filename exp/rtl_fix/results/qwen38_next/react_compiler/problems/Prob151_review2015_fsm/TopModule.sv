module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    localparam [9:0]
        S_IDLE   = 10'b0000000001,  // searching for start of 1101
        S_GOT1   = 10'b0000000010,  // saw 1
        S_GOT11  = 10'b0000000100,  // saw 11
        S_GOT110 = 10'b0000001000,  // saw 110
        S_SHIFT1 = 10'b0000010000,  // shift cycle 1
        S_SHIFT2 = 10'b0000100000,  // shift cycle 2
        S_SHIFT3 = 10'b0001000000,  // shift cycle 3
        S_SHIFT4 = 10'b0010000000,  // shift cycle 4
        S_COUNT  = 10'b0100000000,  // waiting for counters
        S_DONE   = 10'b1000000000;  // notify user, wait for ack

    reg [9:0] state, next_state;

    // State register (synchronous, active-high reset)
    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE:
                next_state = data ? S_GOT1 : S_IDLE;

            S_GOT1:                      // have "1"
                next_state = data ? S_GOT11 : S_IDLE;

            S_GOT11:                     // have "11"
                next_state = data ? S_GOT11 : S_GOT110;

            S_GOT110:                    // have "110"
                next_state = data ? S_SHIFT1 : S_IDLE;

            S_SHIFT1: next_state = S_SHIFT2;
            S_SHIFT2: next_state = S_SHIFT3;
            S_SHIFT3: next_state = S_SHIFT4;
            S_SHIFT4: next_state = S_COUNT;

            S_COUNT:
                next_state = done_counting ? S_DONE : S_COUNT;

            S_DONE:
                next_state = ack ? S_IDLE : S_DONE;

            default:
                next_state = S_IDLE;
        endcase
    end

    // Output logic (Moore)
    assign shift_ena = |state[7:4];   // asserted for exactly 4 cycles
    assign counting  = state[8];
    assign done      = state[9];

endmodule
