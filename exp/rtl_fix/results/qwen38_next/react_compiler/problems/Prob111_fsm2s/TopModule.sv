module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state; // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;
        else begin
            case (state)
                1'b0: begin // OFF
                    if (j)
                        state <= 1'b1;
                    else
                        state <= 1'b0;
                end
                1'b1: begin // ON
                    if (k)
                        state <= 1'b0;
                    else
                        state <= 1'b1;
                end
                default: state <= 1'b0;
            endcase
        end
    end

    assign out = state;

endmodule
