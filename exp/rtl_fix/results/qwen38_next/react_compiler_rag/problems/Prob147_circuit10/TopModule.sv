module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg state_reg;

    // Next-state logic derived from the waveform:
    //   state = 0 -> next = a & b
    //   state = 1 -> next = a | b
    always @(posedge clk) begin
        state_reg <= (a & b) | (state_reg & (a | b));
    end

    // Combinational output logic
    assign q     = a ^ b ^ state_reg;
    assign state = state_reg;

endmodule
