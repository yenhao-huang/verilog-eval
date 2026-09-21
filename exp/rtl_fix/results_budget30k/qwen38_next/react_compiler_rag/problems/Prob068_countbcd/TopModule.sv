module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output reg [15:0] q
);

    initial q = 16'd0;

    // enable for digit 1 (tens): ones digit is about to roll over
    assign ena[0] = (q[3:0] == 4'd9);
    // enable for digit 2 (hundreds): tens digit is also rolling over
    assign ena[1] = ena[0] & (q[7:4] == 4'd9);
    // enable for digit 3 (thousands)
    assign ena[2] = ena[1] & (q[11:8] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // ones digit always counts
            if (q[3:0] == 4'd9)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= q[3:0] + 4'd1;

            // tens digit
            if (ena[0]) begin
                if (q[7:4] == 4'd9)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= q[7:4] + 4'd1;
            end

            // hundreds digit
            if (ena[1]) begin
                if (q[11:8] == 4'd9)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= q[11:8] + 4'd1;
            end

            // thousands digit
            if (ena[2]) begin
                if (q[15:12] == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= q[15:12] + 4'd1;
            end
        end
    end

endmodule
