module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;
    reg next_state;

    // State register (asynchronous active-high reset)
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
                if (bump_left)
                    next_state = WALK_RIGHT;   // bumped on left -> walk right
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_right)
                    next_state = WALK_LEFT;    // bumped on right -> walk left
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule
