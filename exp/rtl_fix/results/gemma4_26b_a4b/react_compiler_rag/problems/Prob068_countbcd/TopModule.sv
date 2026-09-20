module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Digit 0 (ones): q[3:0]
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
            end

            // Digit 1 (tens): q[7:4]
            if (q[3:0] == 4'd9) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                end
            end

            // Digit 2 (hundreds): q[11:8]
            if (q[3:0] == 4'd9 && q[7:4] == 4'd9) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                end else begin
                    q[11:8] <= q[11:8] + 4'd1;
                end
            end

            // Digit 3 (thousands): q[15:12]
            if (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[11:8] == 4'd9) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 4'd1;
                end
            end
        end
    end

    // The enable signals indicate when the next digit will be incremented on the next clock edge.
    // ena[0] is for digit 1 (tens), ena[1] is for digit 2 (hundreds), ena[2] is for digit 3 (thousands).
    assign ena[0] = (q[3:0] == 4'd9);
    assign ena[1] = (q[3:0] == 4'd9 && q[7:4] == 4'd9);
    assign ena[2] = (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[11:8] == 4'd9);

endmodule
