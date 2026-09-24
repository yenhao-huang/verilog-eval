module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

    // BCD format: [7:4] = tens digit, [3:0] = ones digit
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            // Increment seconds
            if (ss == 8'h59) begin
                ss <= 8'h00;

                // Increment minutes
                if (mm == 8'h59) begin
                    mm <= 8'h00;

                    // Increment hours and update AM/PM
                    if (hh == 8'h12) begin
                        hh <= 8'h01;
                    end else if (hh == 8'h11) begin
                        hh <= 8'h12;
                        pm <= ~pm;
                    end else if (hh == 8'h09) begin
                        hh <= 8'h10;
                    end else begin
                        hh <= hh + 8'h01;
                    end
                end else begin
                    if (mm[3:0] == 4'h9)
                        mm <= {mm[7:4] + 4'h1, 4'h0};
                    else
                        mm <= mm + 8'h01;
                end
            end else begin
                if (ss[3:0] == 4'h9)
                    ss <= {ss[7:4] + 4'h1, 4'h0};
                else
                    ss <= ss + 8'h01;
            end
        end
    end

endmodule
