module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    localparam IDLE  = 2'd0;
    localparam DATA  = 2'd1;
    localparam STOP  = 2'd2;
    localparam ERROR = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data      <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Start bit is logic 0.
                    if (!in) begin
                        bit_count <= 3'd0;
                        data      <= 8'd0;
                        state     <= DATA;
                    end
                end

                DATA: begin
                    // LSB is received first.
                    // Shift incoming bit into MSB; after 8 bits,
                    // first received bit is in data[0].
                    data <= {in, data[7:1]};

                    if (bit_count == 3'd7) begin
                        bit_count <= 3'd0;
                        state     <= STOP;
                    end else begin
                        bit_count <= bit_count + 3'd1;
                    end
                end

                STOP: begin
                    if (in) begin
                        // Correct stop bit received.
                        out_byte <= data;
                        done     <= 1'b1;
                        state    <= IDLE;
                    end else begin
                        // Framing error: wait for a stop bit.
                        state <= ERROR;
                    end
                end

                ERROR: begin
                    // Wait until a stop bit is found before receiving next byte.
                    if (in) begin
                        out_byte <= data;
                        done     <= 1'b1;
                        state    <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
