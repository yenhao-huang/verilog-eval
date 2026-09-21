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

    parameter WALK_L = 3'd0;
    parameter WALK_R = 3'd1;
    parameter FALL_L = 3'd2;
    parameter FALL_R = 3'd3;
    parameter DIG_L  = 3'd4;
    parameter DIG_R  = 3'd5;
    parameter DEAD   = 3'd6;

    reg [2:0] state, next_state;
    reg [5:0] fall_count, next_count;

    // State register (async active-high reset -> walk left)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK_L;
            fall_count <= 6'd0;
        end else begin
            state      <= next_state;
            fall_count <= next_count;
        end
    end

    // Next-state logic + fall cycle counter
    always @(*) begin
        next_state = state;
        next_count = fall_count;

        case (state)
            WALK_L: begin
                if (!ground) begin            // fall has highest precedence
                    next_state = FALL_L;
                    next_count = 6'd1;
                end else if (dig) begin       // dig next
                    next_state = DIG_L;
                end else if (bump_left) begin // switch direction last
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end

            WALK_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                    next_count = 6'd1;
                end else if (dig) begin
                    next_state = DIG_R;
                end else if (bump_right) begin
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end

            FALL_L: begin
                if (ground) begin
                    next_state = (fall_count > 6'd20) ? DEAD : WALK_L;
                    next_count = 6'd0;
                end else begin
                    next_state = FALL_L;
                    next_count = (fall_count < 6'd21) ? fall_count + 6'd1 : 6'd21;
                end
            end

            FALL_R: begin
                if (ground) begin
                    next_state = (fall_count > 6'd20) ? DEAD : WALK_R;
                    next_count = 6'd0;
                end else begin
                    next_state = FALL_R;
                    next_count = (fall_count < 6'd21) ? fall_count + 6'd1 : 6'd21;
                end
            end

            DIG_L: begin
                if (!ground) begin
                    next_state = FALL_L;
                    next_count = 6'd1;
                end else begin
                    next_state = DIG_L;   // bumps ignored while digging
                end
            end

            DIG_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                    next_count = 6'd1;
                end else begin
                    next_state = DIG_R;
                end
            end

            DEAD: begin
                next_state = DEAD;        // all outputs 0 forever
                next_count = 6'd0;
            end

            default: begin
                next_state = WALK_L;
                next_count = 6'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L || state == FALL_R);
    assign digging    = (state == DIG_L  || state == DIG_R);

endmodule
