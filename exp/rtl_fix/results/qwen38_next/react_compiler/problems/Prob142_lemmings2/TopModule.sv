module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    localparam [1:0] WALK_LEFT  = 2'd0,
                     WALK_RIGHT = 2'd1,
                     FALL_LEFT  = 2'd2,
                     FALL_RIGHT = 2'd3;

    reg [1:0] state, next_state;

    // State register (asynchronous active-high reset to walk left)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;          // ground disappears: bumps ignored
                else if (bump_left)
                    next_state = WALK_RIGHT;         // bumped left (or both) -> switch
                else
                    next_state = WALK_LEFT;
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;          // bumped right (or both) -> switch
                else
                    next_state = WALK_RIGHT;
            end

            FALL_LEFT: begin
                if (ground)
                    next_state = WALK_LEFT;          // resume previous direction
                else
                    next_state = FALL_LEFT;
            end

            FALL_RIGHT: begin
                if (ground)
                    next_state = WALK_RIGHT;
                else
                    next_state = FALL_RIGHT;
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule
