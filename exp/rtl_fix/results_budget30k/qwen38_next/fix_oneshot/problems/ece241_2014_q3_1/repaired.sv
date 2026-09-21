module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] (ab=00): mux(select=c, in0=d, in1=1)
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] (ab=01): constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): mux(select=c, in0=0, in1=d)
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] (ab=10): mux(select=d, in0=1, in1=c)
    assign mux_in[3] = d ? c : 1'b1;
endmodule
