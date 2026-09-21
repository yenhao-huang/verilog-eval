module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    localparam IDLE  = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;
    localparam WAIT  = 2'd3;

    reg [1:0] state;
    reg [7:0] byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            done      <= 1'b0;
            out_bytes <= 24'd0;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE2;
                    end
                end

                BYTE2: begin
                    done <= 1'b0;
                    byte2 <= in;
                    state <= BYTE3;
                end

                BYTE3: begin
                    done <= 1'b0;
                    out_bytes <= {byte1, byte2, in};
                    state <= WAIT;
                end

                WAIT: begin
                    // This is the cycle immediately after the third byte.
                    done <= 1'b1;

                    // The current byte may also be the start of the next message.
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE2;
                    end else begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                    done  <= 1'b0;
                end
            endcase
        end
    end

endmodule
