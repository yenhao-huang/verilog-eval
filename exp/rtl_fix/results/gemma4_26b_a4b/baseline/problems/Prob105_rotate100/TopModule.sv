module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

    // Internal register to hold the state of the rotator
    reg [99:0] q_reg;

    // Synchronous logic triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (load) begin
            // (1) Synchronous load: Load the register with the input data
            q_reg <= data;
        end else begin
            // (2) Synchronous enable/direction control
            case (ena)
                2'b01: begin
                    // (a) Rotate right by one bit:
                    // The bit at index 0 moves to index 99, 
                    // and bits 99 down to 1 shift down to 98 down to 0.
                    q_reg <= {q_reg[0], q_reg[99:1]};
                end
                2'b10: begin
                    // (b) Rotate left by one bit:
                    // The bit at index 99 moves to index 0,
                    // and bits 98 down to 0 shift up to 99 down to 1.
                    q_reg <= {q_reg[98:0], q_reg[99]};
                end
                // (c) 2'b00 and 2'b11: Do not rotate (hold current value)
                default: begin
                    q_reg <= q_reg;
                end
            endcase
        end
    end

    // Assign the internal register to the output port
    assign q = q_reg;

endmodule
