module top_module (
    input  sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Combinational 2-to-1 mux: sel = 0 -> a, sel = 1 -> b
    assign out = sel ? b : a;

endmodule
