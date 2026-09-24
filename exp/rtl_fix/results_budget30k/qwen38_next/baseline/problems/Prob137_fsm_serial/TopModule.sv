module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    localparam IDLE    = 2'd0;
    localparam DATA    = 2'd1;
    localparam STOP    = 2'd2;
    localparam RECOVER = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    if (!in) begin
                        state <= DATA;
                    end
                end

                DATA: begin
                    if (bit_count == 3'd7) begin
                        state     <= STOP;
                        bit_count <= 3'd0;
                    end else begin
                        bit_count <= bit_count + 3'd1;
                    end
                end

                STOP: begin
                    if (in) begin
                        state <= IDLE;
                    end else begin
                        state <= RECOVER;
                    end
                end

                RECOVER: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state     <= IDLE;
                    bit_count <= 3'd0;
                end
            endcase
        end
    end

    assign done = (state == STOP) && in;

endmodule
