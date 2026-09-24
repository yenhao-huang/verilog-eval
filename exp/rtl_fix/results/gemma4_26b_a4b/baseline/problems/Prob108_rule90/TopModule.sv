module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    // Internal register to hold the current state of the 512-cell system
    reg [511:0] q_reg;

    // Continuous assignment to drive the output port
    assign q = q_reg;

    // Sequential logic triggered on the positive edge of the clock
    always @(posedge clk) begin
        if (load) begin
            // If load is high, the system state is updated with the input data
            q_reg <= data;
        end else begin
            /* 
             * Rule 90 implementation:
             * The next state of each cell is the XOR of its two neighbors.
             * q_next[i] = q[i-1] ^ q[i+1]
             * 
             * Boundary conditions: q[-1] = 0 and q[512] = 0.
             * 
             * Using bitwise shifts:
             * (q_reg << 1) shifts every bit to the left, so the bit at index i 
             * becomes the bit that was at index i-1. The LSB (index 0) becomes 0.
             * (q_reg >> 1) shifts every bit to the right, so the bit at index i 
             * becomes the bit that was at index i+1. The MSB (index 511) becomes 0.
             * 
             * XORing these two results provides the Rule 90 logic:
             * q_next[i] = (q_reg << 1)[i] ^ (q_reg >> 1)[i]
             *           = q_reg[i-1] ^ q_reg[i+1]
             * 
             * For index 0: (0) ^ q_reg[1] = q_reg[1] (Matches q[-1]=0)
             * For index 511: q_reg[510] ^ (0) = q_reg[510] (Matches q[512]=0)
             */
            q_reg <= (q_reg << 1) ^ (q_reg >> 1);
        end
    end

endmodule
