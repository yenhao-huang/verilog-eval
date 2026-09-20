module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

    // Module A instances: z = (x ^ y) & x
    wire a1 = (x ^ y) & x;
    wire a2 = (x ^ y) & x;

    // Module B instances (derived from waveform): z = ~(x ^ y)  (XNOR)
    wire b1 = ~(x ^ y);
    wire b2 = ~(x ^ y);

    // First pair -> OR gate
    wire or_out  = a1 | b1;

    // Second pair -> AND gate
    wire and_out = a2 & b2;

    // OR and AND outputs -> XOR gate -> z
    assign z = or_out ^ and_out;

endmodule
