module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    // The module implements a 64-bit arithmetic shift register.
    // It supports synchronous loading and conditional shifting based on the 'ena' signal.
    // The 'amount' signal determines the direction and the number of bits to shift.

    always @(posedge clk) begin
        if (load) begin
            // (1) load: Loads shift register with data[63:0] instead of shifting.
            // Active high and synchronous.
            q <= data;
        end else if (ena) begin
            // (2) ena: Chooses whether to shift. Active high.
            // (3) amount: Chooses which direction and how much to shift.
            case (amount)
                2'b00: begin
                    // (a) shift left by 1 bit.
                    q <= q << 1;
                end
                2'b01: begin
                    // (b) shift left by 8 bits.
                    q <= q << 8;
                end
                2'b10: begin
                    // (c) shift right by 1 bit (arithmetic).
                    // Using $signed() ensures the >>> operator performs an arithmetic shift.
                    q <= $signed(q) >>> 1;
                end
                2'b11: begin
                    // (d) shift right by 8 bits (arithmetic).
                    q <= $signed(q) >>> 8;
                end
                default: begin
                    // Default case for safety, though amount is 2 bits.
                    q <= q;
                end
            endcase
        end
        // If neither load nor ena is high, q retains its current value.
    end

endmodule
