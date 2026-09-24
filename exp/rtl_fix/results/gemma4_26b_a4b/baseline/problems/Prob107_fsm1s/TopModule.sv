module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    // We use 1-bit encoding since there are only two states.
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state;

    // State transition logic
    // This is a Moore machine, so the output depends only on the current state.
    // The reset is synchronous and active-high.
    always @(posedge clk) begin
        if (reset) begin
            // Reset state is B
            state <= STATE_B;
        end else begin
            case (state)
                STATE_B: begin
                    if (in == 1'b0) begin
                        state <= STATE_A;
                    end else begin
                        state <= STATE_B;
                    end
                end
                STATE_A: begin
                    if (in == 1'b0) begin
                        state <= STATE_B;
                    end else begin
                        state <= STATE_A;
                    end
                end
                default: begin
                    state <= STATE_B;
                end
            endcase
        end
    end

    // Output logic
    // State B has out=1, State A has out=0.
    assign out = (state == STATE_B);

endmodule
