module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

    /**
     * A priority encoder is a combinational circuit that outputs the position 
     * of the first '1' bit encountered in the input vector.
     * 
     * Based on the provided example (8'b10010000 -> 4), the "first" bit is 
     * the one with the lowest index (LSB priority).
     * 
     * Requirement: If no bits are high (input is zero), output zero.
     * 
     * Truth Table for 4-bit priority encoder:
     * in[3:0] | pos[1:0]
     * --------|---------
     * 0000    | 00 (Special case: input is zero)
     * 0001    | 00 (Bit 0 is high)
     * 001x    | 01 (Bit 1 is high)
     * 01xx    | 10 (Bit 2 is high)
     * 1xxx    | 11 (Bit 3 is high)
     */

    always @(*) begin
        if (in[0]) begin
            // Bit 0 is the highest priority
            pos = 2'b00;
        end else if (in[1]) begin
            // Bit 1 is the next priority
            pos = 2'b01;
        end else if (in[2]) begin
            // Bit 2 is the next priority
            pos = 2'b10;
        end else if (in[3]) begin
            // Bit 3 is the lowest priority
            pos = 2'b11;
        end else begin
            // If no bits are high (input is 0), output zero as per instructions
            pos = 2'b00;
        end
    end

endmodule
