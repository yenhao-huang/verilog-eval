module A (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

// Module B is described by the simulation waveform:
// time  x  y  z
// 0ns   0  0  1
// 25ns  1  0  0
// 35ns  0  1  0
// 45ns  1  1  1
// Analyzing the truth table for Module B:
// x=0, y=0: z=1
// x=1, y=0: z=0
// x=0, y=1: z=0
// x=1, y=1: z=1
// This is equivalent to: z = ~(x ^ y).
module B (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module implementation
// The module is implemented with two A submodules and two B submodules.
// The first input of all four submodules is connected to input 'x', 
// and the second input of all four submodules is connected to 'y'.
// The output of the first A submodule is connected to a two-input OR, 
// along with the output of the first B submodule.
// The second pair of A and B submodules is similarly connected to an AND gate.
// The output of the OR and the AND is connected to an XOR, whose output is 'z'.
module top (
    input x,
    input y,
    output z
);
    wire a1, b1, a2, b2;
    wire or_out, and_out;

    // Instantiate the first pair of submodules
    A sub_a1 (.x(x), .y(y), .z(a1));
    B sub_b1 (.x(x), .y(y), .z(b1));

    // Instantiate the second pair of submodules
    A sub_a2 (.x(x), .y(y), .z(a2));
    B sub_b2 (.x(x), .y(y), .z(b2));

    // Connect the first pair to an OR gate
    assign or_out = a1 | b1;

    // Connect the second pair to an AND gate
    assign and_out = a2 & b2;

    // Connect the outputs of the OR and AND gates to an XOR gate
    assign z = or_out ^ and_out;

endmodule
