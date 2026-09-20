module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The ternary operator correctly selects the entire 8-bit bus 
    // based on the value of the 1-bit selector.
    assign out = sel ? b : a;

endmodule
