module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Multiply sel by 4 to get the starting bit index.
    // {sel, 2'b00} is equivalent to sel * 4.
    wire [9:0] base = {sel, 2'b00};

    // Select 4 bits starting at base.
    assign out = in[base +: 4];

endmodule
