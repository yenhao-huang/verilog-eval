module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

    // Module A: z = (x ^ y) & x
    wire a = (x ^ y) & x;

    // Module B: from the waveform, z = 1 when x == y  =>  XNOR
    wire b = ~(x ^ y);

    // First A and B pair -> OR gate
    wire or_out  = a | b;

    // Second A and B pair -> AND gate
    wire and_out = a & b;

    // OR and AND outputs -> XOR -> z
    assign z = or_out ^ and_out;

endmodule
