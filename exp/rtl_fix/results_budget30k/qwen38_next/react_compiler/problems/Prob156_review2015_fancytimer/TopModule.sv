module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    localparam S0    = 4'd0; // searching: no prefix matched
    localparam S1    = 4'd1; // searching: matched 1
    localparam S2    = 4'd2; // searching: matched 11
    localparam S3    = 4'd3; // searching: matched 110
    localparam D0    = 4'd4; // shift in delay[3] (MSB)
    localparam D1    = 4'd5; // shift in delay[2]
    localparam D2    = 4'd6; // shift in delay[1]
    localparam D3    = 4'd7; // shift in delay[0] (LSB)
    localparam COUNT = 4'd8; // counting down
    localparam DONE  = 4'd9; // done, waiting for ack

    reg [3:0] state;
    reg [3:0] delay;
    reg [9:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            state    <= S0;
            delay    <= 4'd0;
            cnt      <= 10'd0;
            count    <= 4'd0;
            counting <= 1'b0;
            done     <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    state    <= data ? S1 : S0;
                end

                S1: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    state    <= data ? S2 : S0;
                end

                S2: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    state    <= data ? S2 : S3;   // 111 -> still matched "11"
                end

                S3: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    state    <= data ? D0 : S0;   // 1101 -> start, else restart
                end

                D0: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    delay[3] <= data;
                    state    <= D1;
                end

                D1: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    delay[2] <= data;
                    state    <= D2;
                end

                D2: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    delay[1] <= data;
                    state    <= D3;
                end

                D3: begin
                    counting <= 1'b1;
                    done     <= 1'b0;
                    delay[0] <= data;
                    count    <= {delay[3:1], data};  // remaining time = delay
                    cnt      <= 10'd999;
                    state    <= COUNT;
                end

                COUNT: begin
                    done <= 1'b0;
                    if (cnt != 10'd0) begin
                        cnt <= cnt - 10'd1;          // 1000 cycles per count value
                    end else begin
                        if (count != 4'd0) begin
                            count <= count - 4'd1;
                            cnt   <= 10'd999;
                        end else begin
                            counting <= 1'b0;
                            done     <= 1'b1;
                            state    <= DONE;
                        end
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    count    <= 4'd0;
                    done     <= 1'b1;
                    if (ack) begin
                        done  <= 1'b0;
                        state <= S0;
                    end
                end

                default: begin
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    state    <= S0;
                end
            endcase
        end
    end

endmodule
