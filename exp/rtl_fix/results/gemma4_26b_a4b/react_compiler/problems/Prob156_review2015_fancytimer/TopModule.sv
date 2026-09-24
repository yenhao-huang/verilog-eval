module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    parameter STATE_SEARCH = 0;
    parameter STATE_S1 = 1;
    parameter STATE_S11 = 2;
    parameter STATE_S110 = 3;
    parameter STATE_GET_DELAY = 4;
    parameter STATE_COUNTING = 5;
    parameter STATE_DONE = 6;

    reg [2:0] state;
    reg [3:0] delay_reg;
    reg [1:0] delay_bit_cnt;
    reg [13:0] cycles_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            delay_reg <= 4'b0;
            delay_bit_cnt <= 2'b0;
            cycles_counter <= 14'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                STATE_SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    if (data) begin
                        state <= STATE_S1;
                    end else begin
                        state <= STATE_SEARCH;
                    end
                end
                STATE_S1: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    if (data) begin
                        state <= STATE_S11;
                    end else begin
                        state <= STATE_SEARCH;
                    end
                end
                STATE_S11: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    if (data) begin
                        state <= STATE_S11;
                    end else begin
                        state <= STATE_S110;
                    end
                end
                STATE_S110: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    if (data) begin
                        state <= STATE_GET_DELAY;
                        delay_reg <= 4'b0;
                        delay_bit_cnt <= 2'b0;
                    end else begin
                        state <= STATE_SEARCH;
                    end
                end
                STATE_GET_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    delay_reg <= {delay_reg[2:0], data};
                    if (delay_bit_cnt == 3) begin
                        state <= STATE_COUNTING;
                        delay_bit_cnt <= 2'b0;
                        cycles_counter <= 14'b0;
                    end else begin
                        delay_bit_cnt <= delay_bit_cnt + 1'b1;
                    end
                end
                STATE_COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // count output: delay_reg - (cycles_counter / 1000)
                    // We need to be careful with the division.
                    // Since cycles_counter is at most 15999, we can use integer division.
                    count <= delay_reg - (cycles_counter / 1000);
                    if (cycles_counter == (delay_reg + 1) * 1000 - 1) begin
                        state <= STATE_DONE;
                        cycles_counter <= 14'b0;
                    end else begin
                        cycles_counter <= cycles_counter + 1'b1;
                    end
                end
                STATE_DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                    if (ack) begin
                        state <= STATE_SEARCH;
                    end else begin
                        state <= STATE_DONE;
                    end
                end
                default: state <= STATE_SEARCH;
            endcase
        end
    end
endmodule
