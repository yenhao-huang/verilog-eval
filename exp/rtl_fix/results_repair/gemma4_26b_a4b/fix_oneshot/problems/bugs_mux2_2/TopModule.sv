module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
);

    // A 2-to-1 mux selects between 'a' and 'b' based on the 'sel' signal.
    // If sel is 0, out = a. If sel is 1, out = b.
    assign out = sel ? b : a;

endmodule
