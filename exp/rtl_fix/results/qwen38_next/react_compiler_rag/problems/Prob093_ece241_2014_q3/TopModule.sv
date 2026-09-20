module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

  // K-map (columns ab = 00, 01, 11, 10 ; rows cd = 00, 01, 11, 10)
  //
  // mux_in[0] (ab=00): cd = 00->0, 01->1, 11->1, 10->1  =>  c OR d
  //     one 2-to-1 mux: sel = c, in1 = 1, in0 = d
  // mux_in[1] (ab=01): all zeros => constant 0 (no mux needed)
  // mux_in[2] (ab=11): cd = 00->0, 01->0, 11->1, 10->0  =>  c AND d
  //     one 2-to-1 mux: sel = c, in1 = d, in0 = 0
  // mux_in[3] (ab=10): cd = 00->1, 01->0, 11->1, 10->1  =>  c OR ~d
  //     one 2-to-1 mux: sel = d, in1 = c, in0 = 1

  assign mux_in[0] = c ? 1'b1 : d;      // c | d
  assign mux_in[1] = 1'b0;              // 0
  assign mux_in[2] = c ? d  : 1'b0;     // c & d
  assign mux_in[3] = d ? c  : 1'b1;     // c | ~d

endmodule
