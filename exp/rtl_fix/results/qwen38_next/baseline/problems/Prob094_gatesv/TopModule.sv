module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i = 0..2
    // out_both[3] is don't-care, assigned 0
    assign out_both = {1'b0, in[3:1] & in[2:0]};

    // out_any[i] = in[i] | in[i-1] for i = 1..3
    // out_any[0] is don't-care, assigned 0
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different[i] = in[i] ^ left_neighbor
    // left neighbor wraps around: in[3]'s left neighbor is in[0]
    assign out_different = {in[3] ^ in[0], in[2:0] ^ in[3:1]};

endmodule
