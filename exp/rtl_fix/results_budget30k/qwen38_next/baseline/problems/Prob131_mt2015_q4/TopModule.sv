module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: inferred from the waveform as an XNOR
// z = 1 for (x,y) = 00 or 11, z = 0 for 01 or 10
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module
// Rename "top" if your environment requires a different top-level module name.
module top (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1, b1, a2, b2;
    wire or_out, and_out;

    // First A and B pair -> OR
    A u_a1 (.x(x), .y(y), .z(a1));
    B u_b1 (.x(x), .y(y), .z(b1));

    // Second A and B pair -> AND
    A u_a2 (.x(x), .y(y), .z(a2));
    B u_b2 (.x(x), .y(y), .z(b2));

    // Combine outputs
    or  u_or  (or_out,  a1, b1);
    and u_and (and_out, a2, b2);
    xor u_xor (z,       or_out, and_out);

endmodule
