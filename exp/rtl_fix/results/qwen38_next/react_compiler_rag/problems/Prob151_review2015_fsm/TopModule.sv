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

    localparam [3:0]
        S0       = 4'd0,   // searching: seen nothing
        S1       = 4'd1,   // seen 1
        S11      = 4'd2,   // seen 11
        S110     = 4'd3,   // seen 110
        SHIFT1   = 4'd4,   // shift cycle 1
        SHIFT2   = 4'd5,   // shift cycle 2
        SHIFT3   = 4'd6,   // shift cycle 3
        SHIFT4   = 4'd7,   // shift cycle 4
        COUNTING = 4'd8,   // waiting for done_counting
        DONE     = 4'd9;   // notify user, waiting for ack

    reg [3:0] state, next_state;

    // state register (synchronous, active-high reset)
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // next-state logic
    always @(*) begin
        case (state)
            S0:       next_state = data ? S1   : S0;
            S1:       next_state = data ? S11  : S0;
            S11:      next_state = data ? S11  : S110;
            S110:     next_state = data ? SHIFT1 : S0;
            SHIFT1:   next_state = SHIFT2;
            SHIFT2:   next_state = SHIFT3;
            SHIFT3:   next_state = SHIFT4;
            SHIFT4:   next_state = COUNTING;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE:     next_state = ack ? S0 : DONE;
            default:  next_state = S0;
        endcase
    end

    // output logic (Moore)
    assign shift_ena = (state == SHIFT1) || (state == SHIFT2) ||
                       (state == SHIFT3) || (state == SHIFT4);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule
