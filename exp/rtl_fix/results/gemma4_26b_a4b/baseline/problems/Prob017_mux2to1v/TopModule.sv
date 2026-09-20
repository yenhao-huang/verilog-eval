module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Implement a 2-1 multiplexer using a conditional assignment.
    // When sel is 1, out gets the value of b.
    // When sel is 0, out gets the value of a.
    assign out = sel ? b : a;

endmodule
