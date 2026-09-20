module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // The module implements a 4-bit register that can either act as 
    // a shift register or a down counter based on the enable signals.
    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift in data MSB-first.
            // q[3] receives the new data, and the existing bits shift right.
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement the current value of the register.
            q <= q - 4'd1;
        end
    end

endmodule
