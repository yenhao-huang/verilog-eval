module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire [2:0] popcount;

    // Sum the individual bits (zero-extended) to count the number of '1's
    assign popcount = {2'b00, in[0]} + {2'b00, in[1]} + {2'b00, in[2]};

    assign out = popcount[1:0];

endmodule
