module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'h0;
        end else begin
            // Digit 0 (ones)
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
            end

            // Digit 1 (tens)
            if (q[3:0] == 4'd9) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                end
            end

            // Digit 2 (hundreds)
            if (q[3:0] == 4'd9 && q[7:4] == 4'd9) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                end else begin
                    q[11:8] <= q[11:8] + 4'd1;
                end
            end

            // Digit 3 (thousands)
            if (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[11:8] == 4'd9) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 4'd1;
                end
            end
        end
    end

    // The enable signals indicate when each of the upper three digits (1, 2, 3) should be incremented.
    // Digit 1 increments when Digit 0 is 9.
    // Digit 2 increments when Digit 0 and Digit 1 are both 9.
    // Digit 3 increments when Digit 0, Digit 1, and Digit 2 are all 9.
    assign ena[0] = (q[3:0] == 4'd9);
    assign ena[1] = (q[3:0] == 4'd9 && q[7:4] == 4'd9);
    assign ena[2] = (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[11:8] == 4'd9);

endmodule
