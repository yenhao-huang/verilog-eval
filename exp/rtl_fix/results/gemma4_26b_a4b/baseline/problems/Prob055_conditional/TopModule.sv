module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Internal wires to store intermediate minimum values
    wire [7:0] min_ab;
    wire [7:0] min_cd;

    // Compare a and b to find the smaller value
    assign min_ab = (a < b) ? a : b;

    // Compare c and d to find the smaller value
    assign min_cd = (c < d) ? c : d;

    // Compare the two intermediate minimums to find the overall minimum
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule
