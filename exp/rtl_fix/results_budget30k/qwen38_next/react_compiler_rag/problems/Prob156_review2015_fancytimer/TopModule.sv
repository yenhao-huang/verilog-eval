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
        S0     = 4'd0,   // no bits matched
        S1     = 4'd1,   // "1"
        S2     = 4'd2,   // "11"
        S3     = 4'd3,   // "110"
        S4     = 4'd4,   // delay bit 3 (MSB) shifted
        S5     = 4'd5,   // delay bit 2
        S6     = 4'd6,   // delay bit 1
        S7     = 4'd7,   // delay bit 0 (LSB)
        COUNT  = 4'd8,   // counting (delay+1)*1000 cycles
        DONE   = 4'd9;   // assert done, wait for ack

    reg [3:0] state;
    reg [3:0] delay;
    reg [3:0] remaining;
    reg [9:0] cnt1000;

    always @(posedge clk) begin
        if (reset) begin
            state     <= S0;
            delay     <= 4'b0;
            remaining <= 4'b0;
            cnt1000   <= 10'b0;
        end else begin
            case (state)
                // ---- start sequence detection: 1101 ----
                S0: if (data) state <= S1;
                S1: state <= data ? S2 : S0;
                S2: state <= data ? S2 : S3;   // "111" -> suffix "11"
                S3: state <= data ? S4 : S0;   // data=1 completes "1101"

                // ---- shift in 4 delay bits, MSB first ----
                S4: begin delay <= {delay[2:0], data}; state <= S5; end
                S5: begin delay <= {delay[2:0], data}; state <= S6; end
                S6: begin delay <= {delay[2:0], data}; state <= S7; end
                S7: begin
                    delay     <= {delay[2:0], data};
                    remaining <= {delay[2:0], data};
                    cnt1000   <= 10'b0;
                    state     <= COUNT;
                end

                // ---- countdown: (delay+1)*1000 cycles ----
                COUNT: begin
                    if (cnt1000 == 10'd999) begin
                        cnt1000 <= 10'b0;
                        if (remaining == 4'b0)
                            state <= DONE;
                        else
                            remaining <= remaining - 4'b1;
                    end else begin
                        cnt1000 <= cnt1000 + 10'b1;
                    end
                end

                // ---- notify user, wait for acknowledge ----
                DONE: if (ack) state <= S0;

                default: state <= S0;
            endcase
        end
    end

    assign count    = (state == COUNT) ? remaining : 4'b0;  // don't-care otherwise
    assign counting = (state == COUNT);
    assign done     = (state == DONE);

endmodule
