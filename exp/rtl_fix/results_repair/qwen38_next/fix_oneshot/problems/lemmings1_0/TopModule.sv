module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter WL = 1'b0;
    parameter WR = 1'b1;

    reg state = WL;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
        end else begin
            if (bump_left && bump_right) begin
                state <= ~state;
            end else if (bump_left) begin
                state <= WR;
            end else if (bump_right) begin
                state <= WL;
            end
        end
    end

    assign walk_left  = (state == WL);
    assign walk_right = (state == WR);

endmodule
