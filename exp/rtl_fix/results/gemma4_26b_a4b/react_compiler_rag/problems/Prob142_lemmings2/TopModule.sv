module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    parameter STATE_WL = 2'b00;
    parameter STATE_WR = 2'b01;
    parameter STATE_F_WL = 2'b10;
    parameter STATE_F_WR = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WL;
        end else begin
            case (state)
                STATE_WL: begin
                    if (!ground) begin
                        state <= STATE_F_WL;
                    end else begin
                        if (bump_left) begin
                            state <= STATE_WR;
                        end else if (bump_right) begin
                            state <= STATE_WL;
                        end else begin
                            state <= STATE_WL;
                        end
                    end
                end
                STATE_WR: begin
                    if (!ground) begin
                        state <= STATE_F_WR;
                    end else begin
                        if (bump_right) begin
                            state <= STATE_WL;
                        end else if (bump_left) begin
                            state <= STATE_WR;
                        end else begin
                            state <= STATE_WR;
                        end
                    end
                end
                STATE_F_WL: begin
                    if (ground) begin
                        state <= STATE_WL;
                    end else begin
                        state <= STATE_F_WL;
                    end
                end
                STATE_F_WR: begin
                    if (ground) begin
                        state <= STATE_WR;
                    end else begin
                        state <= STATE_F_WR;
                    end
                end
                default: state <= STATE_WL;
            endcase
        end
    end

    assign walk_left = (state == STATE_WL);
    assign walk_right = (state == STATE_WR);
    assign aaah = (state == STATE_F_WL || state == STATE_F_WR);

endmodule
