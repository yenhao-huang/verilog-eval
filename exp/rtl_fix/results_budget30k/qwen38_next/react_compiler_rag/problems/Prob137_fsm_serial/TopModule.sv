module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

    localparam [1:0] IDLE  = 2'd0,
                     DATA  = 2'd1,
                     STOP  = 2'd2,
                     ERROR = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] bit_count, next_bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 4'd0;
        end else begin
            state     <= next_state;
            bit_count <= next_bit_count;
        end
    end

    always @(*) begin
        next_state     = state;
        next_bit_count = bit_count;

        case (state)
            IDLE: begin
                if (!in) begin
                    next_state     = DATA;
                    next_bit_count = 4'd0;
                end else begin
                    next_state     = IDLE;
                    next_bit_count = 4'd0;
                end
            end

            DATA: begin
                if (bit_count == 4'd7) begin
                    next_state     = STOP;
                    next_bit_count = 4'd0;
                end else begin
                    next_state     = DATA;
                    next_bit_count = bit_count + 4'd1;
                end
            end

            STOP: begin
                if (in) begin
                    next_state     = IDLE;
                    next_bit_count = 4'd0;
                end else begin
                    next_state     = ERROR;
                    next_bit_count = 4'd0;
                end
            end

            ERROR: begin
                if (in) begin
                    next_state     = IDLE;
                    next_bit_count = 4'd0;
                end else begin
                    next_state     = ERROR;
                    next_bit_count = 4'd0;
                end
            end

            default: begin
                next_state     = IDLE;
                next_bit_count = 4'd0;
            end
        endcase
    end

    assign done = (state == STOP) && in;

endmodule
