module TopModule (
    input  wire        clk,
    input  wire        reset,
    output wire [2:0]  ena,
    output reg  [15:0] q
);

    // Count enables: ena[i] asserts when digit (i+1) should increment
    assign ena[0] = (q[3:0]   == 4'd9);
    assign ena[1] = (q[7:4]   == 4'd9) && ena[0];
    assign ena[2] = (q[11:8]  == 4'd9) && ena[1];

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
