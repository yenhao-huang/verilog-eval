module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // 1. XOR gate using an assign statement (continuous assignment)
    assign out_assign = a ^ b;

    // 2. XOR gate using a combinational always block
    // The @(*) sensitivity list ensures the block triggers on any change to inputs
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // 3. XOR gate using a clocked always block (sequential logic)
    // This implements a flip-flop, meaning the output is updated on the rising edge of the clock
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
