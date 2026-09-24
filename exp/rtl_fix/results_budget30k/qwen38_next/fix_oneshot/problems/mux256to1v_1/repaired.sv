module top_module (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    wire [9:0] base;
    assign base = {sel, 2'b00};
    assign out = in[base +: 4];
endmodule
