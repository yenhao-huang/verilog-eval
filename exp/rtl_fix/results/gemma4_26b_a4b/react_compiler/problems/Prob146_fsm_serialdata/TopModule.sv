module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    parameter IDLE = 3'd0;
    parameter DATA = 3'd1;
    parameter STOP_CHECK = 3'd2;
    parameter WAIT_STOP = 3'd3;

    reg [2:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            data_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0; // Default value for done
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= DATA;
                        bit_cnt <= 0;
                    end
                end
                DATA: begin
                    data_reg[bit_cnt] <= in;
                    if (bit_cnt == 7) begin
                        state <= STOP_CHECK;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
                STOP_CHECK: begin
                    if (in) begin
                        done <= 1;
                        out_byte <= data_reg;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end
                WAIT_STOP: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
