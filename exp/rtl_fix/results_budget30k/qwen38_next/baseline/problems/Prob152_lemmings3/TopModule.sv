module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    localparam [2:0] WALK_LEFT  = 3'd0,
                     WALK_RIGHT = 3'd1,
                     FALL_LEFT  = 3'd2,
                     FALL_RIGHT = 3'd3,
                     DIG_LEFT   = 3'd4,
                     DIG_RIGHT  = 3'd5;

    reg [2:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left && bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left && bump_right) begin
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL_LEFT: begin
                next_state = ground ? WALK_LEFT : FALL_LEFT;
            end

            FALL_RIGHT: begin
                next_state = ground ? WALK_RIGHT : FALL_RIGHT;
            end

            DIG_LEFT: begin
                next_state = ground ? DIG_LEFT : FALL_LEFT;
            end

            DIG_RIGHT: begin
                next_state = ground ? DIG_RIGHT : FALL_RIGHT;
            end

            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule
