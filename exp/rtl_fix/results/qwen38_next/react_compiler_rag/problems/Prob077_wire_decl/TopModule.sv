module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

  wire w1;
  wire w2;

  assign w1    = a & b;   // first AND gate
  assign w2    = c & d;   // second AND gate
  assign out   = w1 | w2; // OR gate drives out (also feeds the NOT gate)
  assign out_n = ~out;    // inverted output

endmodule
