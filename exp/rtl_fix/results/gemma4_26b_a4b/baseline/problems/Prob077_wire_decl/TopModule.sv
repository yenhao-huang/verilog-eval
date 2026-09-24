module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Intermediate wires to connect the AND gates to the OR gate
    wire and_ab;
    wire wire_cd;

    // First layer: Two AND gates
    // The first AND gate takes inputs a and b
    assign and_ab = a & b;
    // The second AND gate takes inputs c and d
    assign wire_cd = c & d;

    // Second layer: OR gate
    // The OR gate takes the outputs of the two AND gates and drives 'out'
    assign out = and_ab | wire_cd;

    // The output 'out_n' is the inverse of 'out'
    assign out_n = ~out;

endmodule
