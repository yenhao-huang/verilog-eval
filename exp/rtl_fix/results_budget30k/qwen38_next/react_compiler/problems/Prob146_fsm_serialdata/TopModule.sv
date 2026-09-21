module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    localparam IDLE      = 2'd0;   // line idle, waiting for start bit (0)
    localparam DATA      = 2'd1;   // shifting in 8 data bits, LSB first
    localparam STOP      = 2'd2;   // checking the stop bit (1)
    localparam WAIT_STOP = 2'd3;   // stop bit error: wait until a 1 is found

    reg [1:0] state;
    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            count    <= 3'd0;
            out_byte <= 8'd0;
            done     <= 1'b0;
        end else begin
            done <= 1'b0;               // done is a one-cycle pulse
            case (state)
                IDLE: begin
                    if (!in) begin      // start bit detected
                        state <= DATA;
                        count <= 3'd0;
                    end
                end

                DATA: begin
                    out_byte[count] <= in;          // LSB first
                    if (count == 3'd7) begin
                        state <= STOP;
                        count <= 3'd0;
                    end else begin
                        count <= count + 3'd1;
                    end
                end

                STOP: begin
                    if (in) begin                   // valid stop bit
                        done  <= 1'b1;
                        state <= IDLE;
                    end else begin                  // framing error
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in) begin                   // found a stop bit again
                        done  <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                    count <= 3'd0;
                end
            endcase
        end
    end
endmodule
