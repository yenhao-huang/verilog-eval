module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    reg state;
    reg next_state;

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            OFF: begin
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: begin
                next_state = OFF;
            end
        endcase
    end

    assign out = state;

endmodule
