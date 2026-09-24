module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

  // (~x ^ y) is the XNOR of x and y, i.e., 1 when the two bits are equal.
  // out[24] = ~a ^ a, out[23] = ~a ^ b, ..., out[1] = ~e ^ d, out[0] = ~e ^ e
  assign out = {
      ~(a ^ a), ~(a ^ b), ~(a ^ c), ~(a ^ d), ~(a ^ e),
      ~(b ^ a), ~(b ^ b), ~(b ^ c), ~(b ^ d), ~(b ^ e),
      ~(c ^ a), ~(c ^ b), ~(c ^ c), ~(c ^ d), ~(c ^ e),
      ~(d ^ a), ~(d ^ b), ~(d ^ c), ~(d ^ d), ~(d ^ e),
      ~(e ^ a), ~(e ^ b), ~(e ^ c), ~(e ^ d), ~(e ^ e)
  };

endmodule
