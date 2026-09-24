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

    localparam [2:0]
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5,
        SPLAT      = 3'd6;

    reg [2:0] state;
    reg [5:0] fall_count;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK_LEFT;
            fall_count <= 6'd0;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state      <= FALL_LEFT;
                        fall_count <= 6'd1;
                    end else if (dig) begin
                        state <= DIG_LEFT;
                    end else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end
                end

                WALK_RIGHT: begin
                    if (!ground) begin
                        state      <= FALL_RIGHT;
                        fall_count <= 6'd1;
                    end else if (dig) begin
                        state <= DIG_RIGHT;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end
                end

                FALL_LEFT: begin
                    if (ground) begin
                        if (fall_count > 6'd20) begin
                            state <= SPLAT;
                        end else begin
                            state <= WALK_LEFT;
                        end
                        fall_count <= 6'd0;
                    end else begin
                        if (fall_count < 6'd21) begin
                            fall_count <= fall_count + 6'd1;
                        end
                    end
                end

                FALL_RIGHT: begin
                    if (ground) begin
                        if (fall_count > 6'd20) begin
                            state <= SPLAT;
                        end else begin
                            state <= WALK_RIGHT;
                        end
                        fall_count <= 6'd0;
                    end else begin
                        if (fall_count < 6'd21) begin
                            fall_count <= fall_count + 6'd1;
                        end
                    end
                end

                DIG_LEFT: begin
                    if (!ground) begin
                        state      <= FALL_LEFT;
                        fall_count <= 6'd1;
                    end
                end

                DIG_RIGHT: begin
                    if (!ground) begin
                        state      <= FALL_RIGHT;
                        fall_count <= 6'd1;
                    end
                end

                SPLAT: begin
                    // Stay splatted until reset.
                end

                default: begin
                    state      <= WALK_LEFT;
                    fall_count <= 6'd0;
                end
            endcase
        end
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule
