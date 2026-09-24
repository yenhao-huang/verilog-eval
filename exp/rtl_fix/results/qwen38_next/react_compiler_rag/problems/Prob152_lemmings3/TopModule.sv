module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    localparam [2:0] WALK_L = 3'd0,
                     WALK_R = 3'd1,
                     FALL_L = 3'd2,
                     FALL_R = 3'd3,
                     DIG_L  = 3'd4,
                     DIG_R  = 3'd5;

    reg [2:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_L;
        else
            state <= next_state;
    end

    // Next-state logic (precedence: fall > dig > direction switch)
    always @(*) begin
        case (state)
            WALK_L: begin
                if (!ground)
                    next_state = FALL_L;
                else if (dig)
                    next_state = DIG_L;
                else if (bump_left)          // also covers bumped on both sides
                    next_state = WALK_R;
                else
                    next_state = WALK_L;
            end

            WALK_R: begin
                if (!ground)
                    next_state = FALL_R;
                else if (dig)
                    next_state = DIG_R;
                else if (bump_right)         // also covers bumped on both sides
                    next_state = WALK_L;
                else
                    next_state = WALK_R;
            end

            FALL_L: next_state = ground ? WALK_L : FALL_L;
            FALL_R: next_state = ground ? WALK_R : FALL_R;

            DIG_L:  next_state = ground ? DIG_L  : FALL_L;
            DIG_R:  next_state = ground ? DIG_R  : FALL_R;

            default: next_state = WALK_L;
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L)  || (state == DIG_R);

endmodule
