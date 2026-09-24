module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Internal register to hold the state of the four D flip-flops
    reg [3:0] shift_reg;

    // Sequential logic block
    // Triggered on the positive edge of the clock
    always @(posedge clk) begin
        if (!resetn) begin
            // Synchronous active-low reset: clear all flip-flops
            shift_reg <= 4'b0000;
        end else begin
            // Shift logic:
            // The new input 'in' enters the first stage (LSB),
            // and existing bits shift towards the MSB.
            // shift_reg[0] <= in;
            // shift_reg[1] <= shift_reg[0];
            // shift_reg[2] <= shift_reg[1];
            // shift_reg[3] <= shift_reg[2];
            shift_reg <= {shift_reg[2:0], in};
        end
    end

    // The output is the value of the fourth D flip-flop
    assign out = shift_reg[3];

endmodule
