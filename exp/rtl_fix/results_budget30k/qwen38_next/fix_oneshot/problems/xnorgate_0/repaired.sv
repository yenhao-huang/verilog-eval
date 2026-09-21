module top_module(
    input a, 
    input b,
    output out
);

    xnor #1 xnor_gate(out, a, b);

endmodule
