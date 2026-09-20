module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire ena,
    output reg  pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            // 12:00 AM
            pm <= 1'b0;
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            if (ss == 8'h59) begin
                ss <= 8'h00;

                if (mm == 8'h59) begin
                    mm <= 8'h00;

                    if (hh == 8'h12) begin
                        // 12 -> 01 and flip AM/PM
                        hh <= 8'h01;
                        pm <= ~pm;
                    end else begin
                        // BCD increment of hour
                        if (hh[3:0] == 4'h9)
                            hh <= {hh[7:4] + 4'd1, 4'd0};
                        else
                            hh <= {hh[7:4], hh[3:0] + 4'd1};

                        // 11 -> 12 flips AM/PM
                        if (hh == 8'h11)
                            pm <= ~pm;
                    end
                end else begin
                    // BCD increment of minute
                    if (mm[3:0] == 4'h9)
                        mm <= {mm[7:4] + 4'd1, 4'd0};
                    else
                        mm <= {mm[7:4], mm[3:0] + 4'd1};
                end
            end else begin
                // BCD increment of second
                if (ss[3:0] == 4'h9)
                    ss <= {ss[7:4] + 4'd1, 4'd0};
                else
                    ss <= {ss[7:4], ss[3:0] + 4'd1};
            end
        end
    end

endmodule
