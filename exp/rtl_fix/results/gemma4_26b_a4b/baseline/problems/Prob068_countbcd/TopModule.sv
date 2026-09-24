module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output reg [15:0] q
);

    // The BCD counter consists of 4 digits:
    // q[3:0]   : Ones digit (digit 0)
    // q[7:4]   : Tens digit (digit 1)
    // q[11:8]  : Hundreds digit (digit 2)
    // q[15:12] : Thousands digit (digit 3)
    
    // The enable signals (ena) indicate when the upper three digits (1, 2, and 3) 
    // should be incremented on the next clock edge.
    // Digit 1 increments when Digit 0 is 9.
    // Digit 2 increments when Digit 0 and Digit 1 are both 9.
    // Digit 3 increments when Digit 0, Digit 1, and Digit 2 are all 9.
    
    assign ena[0] = (q[3:0] == 4'd9);
    assign ena[1] = (q[3:0] == 4'd9 && q[7:4] == 4'd9);
    assign ena[2] = (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[11:8] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset
            q <= 16'h0000;
        end else begin
            // Increment the ones digit (digit 0) every clock cycle
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
            end

            // Increment the tens digit (digit 1) if ena[0] is high
            if (ena[0]) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                end
            end

            // Increment the hundreds digit (digit 2) if ena[1] is high
            if (ena[1]) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                end else begin
                    q[11:8] <= q[11:8] + 4'd1;
                end
            end

            // Increment the thousands digit (digit 3) if ena[2] is high
            if (ena[2]) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 4'd1;
                end
            end
        end
    end

endmodule
