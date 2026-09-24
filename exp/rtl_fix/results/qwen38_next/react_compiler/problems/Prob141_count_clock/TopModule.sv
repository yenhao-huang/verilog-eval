module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg       pm_r;
    reg [7:0] hh_r;
    reg [7:0] mm_r;
    reg [7:0] ss_r;

    assign pm = pm_r;
    assign hh = hh_r;
    assign mm = mm_r;
    assign ss = ss_r;

    // BCD increment (two decimal digits packed in one byte)
    function [7:0] bcd_inc;
        input [7:0] v;
        begin
            if (v[3:0] == 4'h9)
                bcd_inc = {v[7:4] + 4'h1, 4'h0};
            else
                bcd_inc = {v[7:4], v[3:0] + 4'h1};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm_r <= 1'b0;      // 12:00 AM
            hh_r <= 8'h12;
            mm_r <= 8'h00;
            ss_r <= 8'h00;
        end
        else if (ena) begin
            if (ss_r == 8'h59) begin
                ss_r <= 8'h00;
                if (mm_r == 8'h59) begin
                    mm_r <= 8'h00;
                    if (hh_r == 8'h12) begin
                        hh_r <= 8'h01;
                    end
                    else begin
                        hh_r <= bcd_inc(hh_r);
                        if (hh_r == 8'h11)          // 11 -> 12 flips AM/PM
                            pm_r <= ~pm_r;
                    end
                end
                else begin
                    mm_r <= bcd_inc(mm_r);
                end
            end
            else begin
                ss_r <= bcd_inc(ss_r);
            end
        end
    end

endmodule
