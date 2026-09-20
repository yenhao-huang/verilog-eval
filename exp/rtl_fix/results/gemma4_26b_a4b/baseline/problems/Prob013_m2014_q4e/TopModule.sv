module TopModule (
    input in1,
    input in2,
    output out
);

    // A 2-input NOR gate implementation
    // The output is 1 only if both in1 and in2 are 0
    assign out = ~(in1 | in2);

endmodule
