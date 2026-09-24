module top_module(
    input a, 
    input b,
    output out
);

    // A NOR gate is the negation of an OR gate.
    // The simplest and most idiomatic way to implement this in Verilog is using a continuous assignment.
    assign out = ~(a | b);

endmodule
