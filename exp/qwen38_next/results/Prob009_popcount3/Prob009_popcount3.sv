module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    assign out = {2'b0, in[0]} + {2'b0, in[1]} + {2'b0, in[2]};

endmodule
