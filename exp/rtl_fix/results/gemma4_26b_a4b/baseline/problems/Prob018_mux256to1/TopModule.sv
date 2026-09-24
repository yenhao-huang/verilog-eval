module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    // The module implements a 256-to-1 multiplexer.
    // Since the input 'in' is a 256-bit vector and 'sel' is an 8-bit 
    // signal (providing 256 unique indices), we can use the index 
    // operator to select the specific bit.
    assign out = in[sel];

endmodule
