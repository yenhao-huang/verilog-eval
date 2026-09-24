module top_module(
    input a,
    input b,
    output out
);
    wire or_output;

    or  or1(or_output, a, b);   // or_output = a | b
    not not1(out, or_output);   // out = ~(a | b)  -> NOR
endmodule
