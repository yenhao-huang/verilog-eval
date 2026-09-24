module TopModule (
    input in1,
    input in2,
    output out
);

    // The circuit describes an AND gate where the in2 input is inverted (has a bubble).
    // This is logically equivalent to: out = in1 AND (NOT in2)
    assign out = in1 & (~in2);

endmodule
