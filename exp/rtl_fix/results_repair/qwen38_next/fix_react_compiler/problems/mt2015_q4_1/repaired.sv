module top_module(
    input x,
    input y,
    output z
);

    // Intermediate signals (would be the wires between submodules/gates)
    wire a1;   // output of first A submodule : (x ^ y) & x
    wire b1;   // output of first B submodule : ~(x ^ y)
    wire a2;   // output of second A submodule
    wire b2;   // output of second B submodule
    wire w_or;   // OR(a1, b1)
    wire w_and;  // AND(a2, b2)

    // Module A behaviour: z = (x ^ y) & x
    assign a1 = (x ^ y) & x;
    assign a2 = (x ^ y) & x;

    // Module B behaviour (from waveform): z = XNOR(x, y)
    assign b1 = ~(x ^ y);
    assign b2 = ~(x ^ y);

    // Gates
    assign w_or  = a1 | b1;
    assign w_and = a2 & b2;

    // Final XOR
    assign z = w_or ^ w_and;

endmodule
