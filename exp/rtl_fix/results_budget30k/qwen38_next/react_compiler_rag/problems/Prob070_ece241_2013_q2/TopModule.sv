module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // On-set: minterms 2 (0010), 7 (0111), 15 (1111)
    // Off-set: 0,1,4,5,6,9,10,13,14
    // Don't-care: 3,8,11,12
    //
    // SOP (group 1s with don't-cares):
    //   cd      -> covers 3,7,11,15
    //   ~a~bc   -> covers 2,3
    assign out_sop = (c & d) | (~a & ~b & c);

    // POS (group 0s with don't-cares):
    //   c        -> covers 0,1,4,5,8,9,12,13
    //   (~b|d)   -> covers 4,6,12,14
    //   (~a|d)   -> covers 8,10,12,14
    assign out_pos = c & (~b | d) & (~a | d);

endmodule
