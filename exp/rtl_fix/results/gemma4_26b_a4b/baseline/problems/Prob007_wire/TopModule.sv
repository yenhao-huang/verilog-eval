module TopModule (
    input in,
    output out
);

    // The module behaves like a wire, so the output is directly assigned to the input.
    assign out = in;

endmodule
