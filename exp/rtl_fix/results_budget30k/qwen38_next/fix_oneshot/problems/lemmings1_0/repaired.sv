module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter WL = 2'b00;
    parameter WR = 2'b01;
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
        end else begin
            case (state)
                WL: begin
                    if (bump_left)
                        state <= WR;
                    else
                        state <= WL;
                end
                WR: begin
                    if (bump_right)
                        state <= WL;
                    else
                        state <= WR;
                end
                default: begin
                    state <= WL;
                end
            endcase
        end
    end

    assign walk_left  = (state == WL);
    assign walk_right = (state == WR);

endmodule
