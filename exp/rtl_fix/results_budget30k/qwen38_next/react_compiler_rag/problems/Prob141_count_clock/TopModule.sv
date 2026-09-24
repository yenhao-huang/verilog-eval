module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // hour == 0 represents 12 o'clock; 1..11 represent 01..11
    reg [3:0] hour;
    reg [5:0] minute;  // 0..59
    reg [5:0] second;  // 0..59

    wire [7:0] hour_val = (hour == 4'd0) ? 8'd12 : {4'd0, hour};

    // BCD conversion
    assign hh = {((hour_val / 10) & 4'hF), (hour_val % 10)};
    assign mm = {((minute / 10) & 4'hF), (minute % 10)};
    assign ss = {((second / 10) & 4'hF), (second % 10)};

    always @(posedge clk) begin
        if (reset) begin
            hour   <= 4'd0;   // 12
            minute <= 6'd0;
            second <= 6'd0;
            pm     <= 1'b0;   // AM
        end else if (ena) begin
            if (second == 6'd59) begin
                second <= 6'd0;
                if (minute == 6'd59) begin
                    minute <= 6'd0;
                    if (hour == 4'd11) begin
                        hour <= 4'd0;   // wrap to 12
                        pm   <= ~pm;    // flip AM/PM
                    end else begin
                        hour <= hour + 4'd1;
                    end
                end else begin
                    minute <= minute + 6'd1;
                end
            end else begin
                second <= second + 6'd1;
            end
        end
    end

endmodule
