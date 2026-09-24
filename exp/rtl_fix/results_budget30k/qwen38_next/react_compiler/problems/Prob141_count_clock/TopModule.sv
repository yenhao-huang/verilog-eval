module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            // 12:00:00 AM
            pm <= 1'b0;
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            if (ss == 8'h59) begin
                ss <= 8'h00;
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                    if (hh == 8'h11) begin
                        hh <= 8'h12;
                        pm <= ~pm;          // wrap 11 -> 12, flip AM/PM
                    end else if (hh == 8'h12) begin
                        hh <= 8'h01;
                    end else if (hh[3:0] == 4'h9) begin
                        hh <= {hh[7:4] + 4'd1, 4'h0};   // 09 -> 10
                    end else begin
                        hh <= {hh[7:4], hh[3:0] + 4'd1};
                    end
                end else begin
                    if (mm[3:0] == 4'h9)
                        mm <= {mm[7:4] + 4'd1, 4'h0};   // carry BCD tens
                    else
                        mm <= {mm[7:4], mm[3:0] + 4'd1};
                end
            end else begin
                if (ss[3:0] == 4'h9)
                    ss <= {ss[7:4] + 4'd1, 4'h0};       // carry BCD tens
                else
                    ss <= {ss[7:4], ss[3:0] + 4'd1};
            end
        end
    end

endmodule
