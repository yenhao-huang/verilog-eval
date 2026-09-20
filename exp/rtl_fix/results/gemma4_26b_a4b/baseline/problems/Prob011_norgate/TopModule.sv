module TopModule (
    input a,
    input b,
    output out
);

    // A NOR gate is the negation of an OR gate.
    // In Verilog, ~ is the bitwise NOT operator and | is the bitwise OR operator.
    assign out = ~(a | b);

endmodule
