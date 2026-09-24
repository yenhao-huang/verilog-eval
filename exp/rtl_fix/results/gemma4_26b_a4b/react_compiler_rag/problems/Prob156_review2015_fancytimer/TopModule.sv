module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    parameter IDLE = 3'd0,
              S1 = 3'd1,
              S11 = 3'd2,
              S110 = 3'd3,
              GET_DELAY = 3'd4,
              COUNTING = 3'd5,
              DONE = 3'd6;

    reg [2:0] state;
    reg [3:0] delay;
    reg [2:0] delay_cnt;
    reg [13:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay <= 4'd0;
            delay_cnt <= 3'd0;
            cycle_count <= 14'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    if (data)
                        state <= S1;
                    else
                        state <= IDLE;
                end

                S1: begin
                    if (data)
                        state <= S11;
                    else
                        state <= IDLE;
                end

                S11: begin
                    if (data)
                        state <= S11;
                    else if (!data)
                        state <= S110; // Wait, if data is 0, it's S110
                    // Wait, the logic for S11 was: if data is 1, stay in S11. If data is 0, go to S110.
                end
                // Let's re-write the state machine more carefully.
            endcase
        end
    end
endmodule
