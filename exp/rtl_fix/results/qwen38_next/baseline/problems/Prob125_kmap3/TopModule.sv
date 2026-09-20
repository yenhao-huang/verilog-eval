module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire out
);

    // The don't-care cells can be chosen to simplify the K-map to:
    // out = a OR (NOT b AND c)
    assign out = a | (~b & c);

endmodule
