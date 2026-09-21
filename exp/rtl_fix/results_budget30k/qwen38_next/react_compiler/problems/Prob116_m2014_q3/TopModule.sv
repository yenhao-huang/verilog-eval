module TopModule (
    input [3:0] x,
    output f
);
    // K-map grouping gives f = x[3] & ~x[1] | x[4] & x[2] in the problem's
    // 1-based labels. Mapping those labels MSB-first to Verilog x[3:0]:
    // x[1]->x[3], x[2]->x[2], x[3]->x[1], x[4]->x[0].
    assign f = (x[1] & ~x[3]) | (x[0] & x[2]);
endmodule
