module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire out,
    output wire out_n
);

    wire ab;
    wire cd;

    assign ab   = a & b;   // first AND gate
    assign cd   = c & d;   // second AND gate
    assign out  = ab | cd; // OR gate drives out (also feeds the NOT gate)
    assign out_n = ~out;   // inverted output

endmodule
