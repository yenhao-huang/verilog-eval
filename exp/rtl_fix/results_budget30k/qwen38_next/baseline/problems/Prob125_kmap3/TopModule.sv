module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // d is a don't-care. Choosing don't-cares to group all a=1 cells gives:
    // out = a OR (c AND NOT b)
    assign out = a | (c & ~b);
endmodule
