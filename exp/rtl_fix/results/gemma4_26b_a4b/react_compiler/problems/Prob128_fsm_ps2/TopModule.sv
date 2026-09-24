module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    parameter STATE_SEARCH = 2'b00;
    parameter STATE_BYTE2  = 2'b01;
    parameter STATE_BYTE3  = 2'b10;
    parameter STATE_DONE   = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            done <= 1'b0;
        end else begin
            case (state)
                STATE_SEARCH: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        state <= STATE_BYTE2;
                    end else begin
                        state <= STATE_SEARCH;
                    end
                end
                STATE_BYTE2: begin
                    done <= 1'b0;
                    state <= STATE_BYTE3;
                end
                STATE_BYTE3: begin
                    done <= 1'b0;
                    state <= STATE_DONE;
                end
                STATE_DONE: begin
                    done <= 1'b1;
                    state <= STATE_SEARCH;
                end
                default: begin
                    state <= STATE_SEARCH;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Wait, there's a small issue. In STATE_DONE, done is 1.
    // But in the next cycle, we transition to STATE_SEARCH.
    // In STATE_SEARCH, we check in[3].
    // Let's re-check the STATE_DONE logic.
    // If state is STATE_DONE, done is 1.
    // In the next cycle, state becomes STATE_SEARCH.
    // In STATE_SEARCH, done is 0.
    // This means done is high for exactly one cycle.
    // Let's re-check the transition from STATE_DONE.
    // If state is STATE_DONE, the next state is STATE_SEARCH.
    // In STATE_SEARCH, if in[3] is 1, state becomes STATE_BYTE2.
    // This seems correct.

endmodule
