module TopModule (
    input a,
    input b,
    input sel,
    output out
);

    // Implement a 2-to-1 multiplexer using a ternary operator.
    // If sel is 1, out = b.
    // If sel is 0, out = a.
    assign out = sel ? b : a;

endmodule
