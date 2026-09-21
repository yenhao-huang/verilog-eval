module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    localparam [3:0] IDLE = 4'd0,   // 0 consecutive 1s (reset state)
                     S1   = 4'd1,   // 1 consecutive 1
                     S2   = 4'd2,   // 2 consecutive 1s
                     S3   = 4'd3,   // 3 consecutive 1s
                     S4   = 4'd4,   // 4 consecutive 1s
                     S5   = 4'd5,   // 5 consecutive 1s
                     S6   = 4'd6,   // 6 consecutive 1s
                     ERR  = 4'd7,   // 7 or more consecutive 1s
                     DISC = 4'd8,   // 0111110 -> discard the 0
                     FLAG = 4'd9;   // 01111110 -> frame flag

    reg [3:0] state, next_state;

    // state register (active-high synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = in ? S1   : IDLE;
            S1:   next_state = in ? S2   : IDLE;
            S2:   next_state = in ? S3   : IDLE;
            S3:   next_state = in ? S4   : IDLE;
            S4:   next_state = in ? S5   : IDLE;
            S5:   next_state = in ? S6   : DISC;   // 5 ones then 0 -> discard
            S6:   next_state = in ? ERR  : FLAG;   // 6 ones then 0 -> flag, 7th 1 -> error
            ERR:  next_state = in ? ERR  : IDLE;   // error persists while 1s continue
            DISC: next_state = in ? S1   : IDLE;   // discarded 0 -> behave as if it wasn't there
            FLAG: next_state = in ? S1   : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Moore outputs: asserted the cycle after the condition occurs, for one full cycle
    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err  = (state == ERR);

endmodule
