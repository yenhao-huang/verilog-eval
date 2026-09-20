module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    localparam LEFT  = 1'b0;
    localparam RIGHT = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            case (state)
                LEFT: begin
                    if (bump_left)
                        state <= RIGHT;
                    else
                        state <= LEFT;
                end
                RIGHT: begin
                    if (bump_right)
                        state <= LEFT;
                    else
                        state <= RIGHT;
                end
                default: state <= LEFT;
            endcase
        end
    end

    // Moore outputs: depend only on the current state
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule
