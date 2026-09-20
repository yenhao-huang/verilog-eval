module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    parameter S_IDLE = 3'd0;
    parameter S_DATA = 3'd1;
    parameter S_STOP = 3'd2;
    parameter S_WAIT_STOP = 3'd3;

    reg [2:0] state;
    reg [2:0] count;

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
                    end
                end
                S_DATA: begin
                    if (count == 7) begin
                        state <= S_STOP;
                    end else begin
                        count <= count + 1;
                    end
                end
                S_STOP: begin
                    if (in == 1) begin
                        done <= 1;
                        state <= S_IDLE;
                    end else begin
                        done <= 0;
                        state <= S_WAIT_STOP;
                    end
                end
                S_WAIT_STOP: begin
                    done <= 0;
                    if (in == 1) begin
                        state <= S_IDLE;
                    end
                end
                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end
endmodule
