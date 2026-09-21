module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg  [7:0]  out_byte,
    output reg         done
);

    // State encoding
    localparam IDLE = 2'd0,   // line idle, waiting for start bit (in == 0)
               DATA = 2'd1,   // receiving 8 data bits, LSB first
               STOP = 2'd2;   // expecting stop bit (in == 1)

    reg [1:0] state;
    reg [2:0] bitcnt;
    reg [7:0] data;

    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            bitcnt   <= 3'd0;
            data     <= 8'd0;
            out_byte <= 8'd0;
            done     <= 1'b0;
        end else begin
            done <= 1'b0;   // default: done is a one-cycle pulse

            case (state)
                IDLE: begin
                    bitcnt <= 3'd0;
                    if (in == 1'b0)          // start bit detected
                        state <= DATA;
                end

                DATA: begin
                    data[bitcnt] <= in;      // LSB first
                    if (bitcnt == 3'd7) begin
                        bitcnt <= 3'd0;
                        state  <= STOP;
                    end else begin
                        bitcnt <= bitcnt + 3'd1;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin    // valid stop bit found
                        state    <= IDLE;
                        done     <= 1'b1;
                        out_byte <= data;
                    end
                    // If no stop bit, remain in STOP until one appears
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
