module TopModule (
    input clk,
    input x,
    output z
);

    // Internal registers to represent the outputs of the three D flip-flops
    reg q1;
    reg q2;
    reg q3;

    // Internal wires for the outputs of the three gates
    wire gate_xor_out;
    wire gate_and_out;
    wire gate_or_out;

    // Initialize the D flip-flops to zero as per the requirement
    // "Assume that the D flip-flops are initially reset to zero before the machine begins."
    initial begin
        q1 = 1'b0;
        q2 = 1'b0;
        q3 = 1'b0;
    end

    // Combinational Logic for the three gates:
    // 1. XOR gate: Input 1 is x, Input 2 is the corresponding flip-flop's output (q1).
    assign gate_xor_out = x ^ q1;

    // 2. AND gate: Input 1 is x, Input 2 is the corresponding flip-flop's complemented output (~q2).
    assign gate_and_out = x & (~q2);

    // 3. OR gate: Input 1 is x, Input 2 is the corresponding flip-flop's complementary output (~q3).
    assign gate_or_out = x | (~q3);

    // Sequential Logic (D Flip-Flops):
    // Triggered on the positive edge of the clock.
    always @(posedge clk) begin
        q1 <= gate_xor_out;
        q2 <= gate_and_out;
        q3 <= gate_or_out;
    end

    // Final Output Logic:
    // A three-input NOR gate whose inputs are the outputs of the three flip-flops.
    assign z = ~(q1 | q2 | q3);

endmodule
