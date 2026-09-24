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

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground)
                        state <= FALL_LEFT;      // ground check has priority over bumps
                    else if (bump_left)
                        state <= WALK_RIGHT;     // also covers bump on both sides
                    else
                        state <= WALK_LEFT;
                end

                WALK_RIGHT: begin
                    if (!ground)
                        state <= FALL_RIGHT;     // ground check has priority over bumps
                    else if (bump_right)
                        state <= WALK_LEFT;      // also covers bump on both sides
                    else
                        state <= WALK_RIGHT;
                end

                FALL_LEFT: begin
                    if (ground)
                        state <= WALK_LEFT;      // resume previous direction, ignore bumps
                    else
                        state <= FALL_LEFT;
                end

                FALL_RIGHT: begin
                    if (ground)
                        state <= WALK_RIGHT;     // resume previous direction, ignore bumps
                    else
                        state <= FALL_RIGHT;
                end

                default: state <= WALK_LEFT;
            endcase
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule
