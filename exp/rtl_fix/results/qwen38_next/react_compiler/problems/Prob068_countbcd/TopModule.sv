module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] q_reg;

    assign q = q_reg;

    // Count-enable outputs: ena[0] -> tens digit, ena[1] -> hundreds, ena[2] -> thousands
    assign ena[0] = (q_reg[3:0]   == 4'd9);
    assign ena[1] = ena[0] && (q_reg[7:4]   == 4'd9);
    assign ena[2] = ena[1] && (q_reg[11:8]  == 4'd9);

    // 4-digit BCD counter with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 16'd0;
        end else begin
            if (q_reg[3:0] == 4'd9) begin
                q_reg[3:0] <= 4'd0;
                if (q_reg[7:4] == 4'd9) begin
                    q_reg[7:4] <= 4'd0;
                    if (q_reg[11:8] == 4'd9) begin
                        q_reg[11:8] <= 4'd0;
                        if (q_reg[15:12] == 4'd9) begin
                            q_reg[15:12] <= 4'd0;
                        end else begin
                            q_reg[15:12] <= q_reg[15:12] + 4'd1;
                        end
                    end else begin
                        q_reg[11:8] <= q_reg[11:8] + 4'd1;
                    end
                end else begin
                    q_reg[7:4] <= q_reg[7:4] + 4'd1;
                end
            end else begin
                q_reg[3:0] <= q_reg[3:0] + 4'd1;
            end
        end
    end

endmodule
