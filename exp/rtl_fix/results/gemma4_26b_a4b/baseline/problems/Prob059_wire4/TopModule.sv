module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    // Continuous assignments to act as wires connecting the inputs to the outputs
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;

endmodule
