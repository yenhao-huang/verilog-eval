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

    // State encoding
    localparam [2:0] WALK_L = 3'd0,
                     WALK_R = 3'd1,
                     FALL_L = 3'd2,
                     FALL_R = 3'd3,
                     DIG_L  = 3'd4,
                     DIG_R  = 3'd5,
                     DEAD   = 3'd6;

    reg [2:0] state;
    reg [5:0] fall_cnt;   // number of clock cycles spent falling

    // Moore outputs
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L)  || (state == DIG_R);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_L;
            fall_cnt <= 6'd0;
        end else begin
            case (state)
                // -------------------------------------------------- walking left
                WALK_L: begin
                    fall_cnt <= 6'd0;
                    if (!ground) begin          // fall has highest precedence
                        state    <= FALL_L;
                        fall_cnt <= 6'd1;       // first cycle in the air
                    end else if (dig) begin     // dig next
                        state <= DIG_L;
                    end else if (bump_left) begin  // switch direction last
                        state <= WALK_R;
                    end else begin
                        state <= WALK_L;
                    end
                end

                // -------------------------------------------------- walking right
                WALK_R: begin
                    fall_cnt <= 6'd0;
                    if (!ground) begin
                        state    <= FALL_R;
                        fall_cnt <= 6'd1;
                    end else if (dig) begin
                        state <= DIG_R;
                    end else if (bump_right) begin
                        state <= WALK_L;
                    end else begin
                        state <= WALK_R;
                    end
                end

                // -------------------------------------------------- falling (was walking left)
                FALL_L: begin
                    if (!ground) begin
                        state <= FALL_L;
                        if (fall_cnt < 6'd21)
                            fall_cnt <= fall_cnt + 6'd1;
                        else
                            fall_cnt <= fall_cnt;   // saturate, unbounded fall
                    end else begin
                        fall_cnt <= 6'd0;
                        state    <= (fall_cnt > 6'd20) ? DEAD : WALK_L;
                    end
                end

                // -------------------------------------------------- falling (was walking right)
                FALL_R: begin
                    if (!ground) begin
                        state <= FALL_R;
                        if (fall_cnt < 6'd21)
                            fall_cnt <= fall_cnt + 6'd1;
                        else
                            fall_cnt <= fall_cnt;
                    end else begin
                        fall_cnt <= 6'd0;
                        state    <= (fall_cnt > 6'd20) ? DEAD : WALK_R;
                    end
                end

                // -------------------------------------------------- digging (left / right)
                DIG_L: begin
                    fall_cnt <= 6'd0;
                    if (!ground) begin
                        state    <= FALL_L;
                        fall_cnt <= 6'd1;
                    end else begin
                        state <= DIG_L;
                    end
                end

                DIG_R: begin
                    fall_cnt <= 6'd0;
                    if (!ground) begin
                        state    <= FALL_R;
                        fall_cnt <= 6'd1;
                    end else begin
                        state <= DIG_R;
                    end
                end

                // -------------------------------------------------- splattered forever
                DEAD: begin
                    state    <= DEAD;
                    fall_cnt <= 6'd0;
                end

                default: begin
                    state    <= WALK_L;
                    fall_cnt <= 6'd0;
                end
            endcase
        end
    end

endmodule
