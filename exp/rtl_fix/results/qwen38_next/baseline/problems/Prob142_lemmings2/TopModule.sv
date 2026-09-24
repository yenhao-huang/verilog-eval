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

    localparam [1:0] WALK_LEFT  = 2'd0;
    localparam [1:0] WALK_RIGHT = 2'd1;
    localparam [1:0] FALL_LEFT  = 2'd2;
    localparam [1:0] FALL_RIGHT = 2'd3;

    reg [1:0] state;

    // Asynchronous active-high reset, clocked on posedge clk
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALL_LEFT;
                    end else if (bump_left) begin
                        // Bumped left -> walk right
                        // If both bumps, this also switches direction
                        state <= WALK_RIGHT;
                    end else begin
                        // bump_right while walking left keeps direction
                        state <= WALK_LEFT;
                    end
                end

                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALL_RIGHT;
                    end else if (bump_right) begin
                        // Bumped right -> walk left
                        // If both bumps, this also switches direction
                        state <= WALK_LEFT;
                    end else begin
                        // bump_left while walking right keeps direction
                        state <= WALK_RIGHT;
                    end
                end

                FALL_LEFT: begin
                    if (ground) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= FALL_LEFT;
                    end
                end

                FALL_RIGHT: begin
                    if (ground) begin
                        state <= WALK_RIGHT;
                    end else begin
                        state <= FALL_RIGHT;
                    end
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
