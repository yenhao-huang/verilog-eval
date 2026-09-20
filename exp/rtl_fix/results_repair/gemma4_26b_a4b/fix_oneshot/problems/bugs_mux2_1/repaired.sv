module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
);

    // A 2-to-1 mux is a combinational circuit.
    // If sel is 0, out should be a.
    // If sel is 1, out should be b.
    assign out = sel ? b : a;

endmodule
