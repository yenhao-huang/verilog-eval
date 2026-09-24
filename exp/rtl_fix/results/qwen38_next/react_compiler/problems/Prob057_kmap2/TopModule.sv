module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire out
);

    assign out = (~b & ~c) | (~a & ~d) | (b & c & d) | (a & c & d);

endmodule
