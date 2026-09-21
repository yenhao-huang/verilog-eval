module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The bug was that 'out' was declared as a single bit, which truncated
    // the 8-bit mux result.  Declare it as 8 bits and perform the mux.
    assign out = sel ? b : a;

endmodule
