module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // State definitions
    parameter S_IDLE  = 3'd0; // Waiting for start bit (0)
    parameter S_DATA  = 3'd1; // Receiving 8 data bits
    parameter S_STOP  = 3'd2; // Verifying stop bit (1)
    parameter S_ERROR = 3'd3; // Waiting for stop bit (1) after error

    reg [2:0] state;
    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            count <= 0;
            done <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 0;
                    if (in == 0) begin
                        state <= S_DATA;
                        count <= 0;
                    end else begin
                        state <= S_IDLE;
                    end
                end

                S_DATA: begin
                    done <= 0;
                    if (count < 7) begin
                        count <= count + 1;
                        state <= S_DATA;
                    end else begin
                        count <= 0;
                        state <= S_STOP;
                    end
                end

                S_STOP: begin
                    if (in == 1) begin
                        done <= 1;
                        state <= S_IDLE;
                    end else begin
                        done <= 0;
                        state <= S_ERROR;
                    end
                end

                S_ERROR: begin
                    done <= 0;
                    if (in == 1) begin
                        state <= S_IDLE;
                    end else begin
                        state <= S_ERROR;
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
