module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

localparam IDLE    = 3'd0;
localparam GOT1    = 3'd1;
localparam GOT11   = 3'd2;
localparam GOT110  = 3'd3;
localparam GOT1101 = 3'd4;
localparam COUNT   = 3'd5;
localparam DONE    = 3'd6;

reg [2:0] state;
reg [3:0] delay;
reg [2:0] bit_count;
reg [9:0] inner;
reg [3:0] count_reg;

assign count    = count_reg;
assign counting = (state == COUNT);
assign done     = (state == DONE);

always @(posedge clk) begin
    if (reset) begin
        state     <= IDLE;
        delay     <= 4'd0;
        bit_count <= 3'd0;
        inner     <= 10'd0;
        count_reg <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                if (data) state <= GOT1;
            end

            GOT1: begin
                if (data) state <= GOT11;
                else      state <= IDLE;
            end

            GOT11: begin
                if (data) state <= GOT11;
                else      state <= GOT110;
            end

            GOT110: begin
                if (data) begin
                    state     <= GOT1101;
                    bit_count <= 3'd0;
                    delay     <= 4'd0;
                end else begin
                    state <= IDLE;
                end
            end

            GOT1101: begin
                delay <= {delay[2:0], data};
                if (bit_count == 3'd3) begin
                    state     <= COUNT;
                    count_reg <= {delay[2:0], data};
                    inner     <= 10'd0;
                end else begin
                    bit_count <= bit_count + 1'b1;
                end
            end

            COUNT: begin
                if (inner == 10'd999) begin
                    inner <= 10'd0;
                    if (count_reg == 4'd0) begin
                        state     <= DONE;
                        count_reg <= 4'd0;
                    end else begin
                        count_reg <= count_reg - 1'b1;
                    end
                end else begin
                    inner <= inner + 1'b1;
                end
            end

            DONE: begin
                if (ack) state <= IDLE;
            end

            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule
