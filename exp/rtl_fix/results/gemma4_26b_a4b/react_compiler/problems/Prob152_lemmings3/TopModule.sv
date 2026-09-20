module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State definitions
    parameter WALK_LEFT  = 3'd0;
    parameter WALK_RIGHT = 3'd1;
    parameter FALL_LEFT  = 3'd2;
    parameter FALL_RIGHT = 3'd3;
    parameter DIG_LEFT   = 3'd4;
    parameter DIG_RIGHT  = 3'd5;

    reg [2:0] state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground)
                        state <= FALL_LEFT;
                    else if (dig)
                        state <= DIG_LEFT;
                    else if (bump_left)
                        state <= WALK_RIGHT;
                    else if (bump_right)
                        state <= WALK_LEFT;
                    else
                        state <= WALK_LEFT;
                end
                WALK_RIGHT: begin
                    if (!ground)
                        state <= FALL_RIGHT;
                    else if (dig)
                        state <= DIG_RIGHT;
                    else if (bump_right)
                        state <= WALK_LEFT;
                    else if (bump_left)
                        state <= WALK_RIGHT;
                    else
                        state <= WALK_RIGHT;
                end
                FALL_LEFT: begin
                    if (ground)
                        state <= WALK_LEFT;
                    else
                        state <= FALL_LEFT;
                end
                FALL_RIGHT: begin
                    if (ground)
                        state <= WALK_RIGHT;
                    else
                        state <= FALL_RIGHT;
                end
                DIG_LEFT: begin
                    if (!ground)
                        state <= FALL_LEFT;
                    else
                        state <= DIG_LEFT;
                end
                DIG_RIGHT: begin
                    if (!ground)
                        state <= FALL_RIGHT;
                    else
                        state <= DIG_RIGHT;
                end
                default: state <= WALK_LEFT;
            endcase
        end
    end

    // Output logic (Moore machine)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        case (state)
            WALK_LEFT:  walk_left = 1;
            WALK_RIGHT: walk_right = 1;
            FALL_LEFT, FALL_RIGHT: aaah = 1;
            DIG_LEFT, DIG_RIGHT:   digging = 1;
        endcase
    end

endmodule
