module TopModule (
    input        clk,
    input        reset,
    input        data,
    output [3:0] count,
    output       counting,
    output       done,
    input        ack
);

    localparam [3:0]
        S_IDLE = 4'd0,
        S_1    = 4'd1,
        S_11   = 4'd2,
        S_110  = 4'd3,
        S_D3   = 4'd4,
        S_D2   = 4'd5,
        S_D1   = 4'd6,
        S_D0   = 4'd7,
        S_COUNT= 4'd8,
        S_DONE = 4'd9;

    reg [3:0] state;
    reg [3:0] delay_reg;
    reg [3:0] count_reg;
    reg [9:0] sub;

    assign count    = count_reg;
    assign counting = (state == S_COUNT);
    assign done     = (state == S_DONE);

    always @(posedge clk) begin
        if (reset) begin
            state     <= S_IDLE;
            delay_reg <= 4'd0;
            count_reg <= 4'd0;
            sub       <= 10'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (data) state <= S_1;
                end

                S_1: begin
                    if (data) state <= S_11;
                    else      state <= S_IDLE;
                end

                S_11: begin
                    if (data) state <= S_11;
                    else      state <= S_110;
                end

                S_110: begin
                    if (data) state <= S_D3;
                    else      state <= S_IDLE;
                end

                S_D3: begin
                    delay_reg[3] <= data;
                    state        <= S_D2;
                end

                S_D2: begin
                    delay_reg[2] <= data;
                    state        <= S_D1;
                end

                S_D1: begin
                    delay_reg[1] <= data;
                    state        <= S_D0;
                end

                S_D0: begin
                    delay_reg[0] <= data;
                    count_reg    <= {delay_reg[3:1], data};
                    sub          <= 10'd0;
                    state        <= S_COUNT;
                end

                S_COUNT: begin
                    if (sub == 10'd999) begin
                        sub <= 10'd0;
                        if (count_reg == 4'd0) begin
                            state <= S_DONE;
                        end else begin
                            count_reg <= count_reg - 4'd1;
                        end
                    end else begin
                        sub <= sub + 10'd1;
                    end
                end

                S_DONE: begin
                    if (ack) state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
