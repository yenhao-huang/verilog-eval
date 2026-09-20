module TopModule (
    input  x,
    input  y,
    output z
);

  // z = XNOR(x, y): matches every row of the waveform
  assign z = ~(x ^ y);

endmodule
