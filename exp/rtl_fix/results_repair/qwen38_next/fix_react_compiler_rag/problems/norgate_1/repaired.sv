module top_module(
    input a,
    input b,
    output out
);
    wire or_output;

    // OR gate: output must be the FIRST port
    or or1(or_output, a, b);

    // NOT gate: output (out) first, input second
    not not1(out, or_output);
endmodule
