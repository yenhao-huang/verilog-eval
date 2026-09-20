module TopModule (
    input  x,
    input  y,
    output z
);

    // Module A: z = (x ^ y) & x
    wire a1 = (x ^ y) & x;
    wire a2 = (x ^ y) & x;

    // Module B: derived from waveform -> z = ~(x ^ y)  (XNOR)
    //   x y z : 0 0 -> 1, 1 0 -> 0, 0 1 -> 0, 1 1 -> 1
    wire b1 = ~(x ^ y);
    wire b2 = ~(x ^ y);

    // First A and B pair -> OR gate
    wire or_out  = a1 | b1;

    // Second A and B pair -> AND gate
    wire and_out = a2 & b2;

    // OR and AND outputs -> XOR -> z
    assign z = or_out ^ and_out;

endmodule
