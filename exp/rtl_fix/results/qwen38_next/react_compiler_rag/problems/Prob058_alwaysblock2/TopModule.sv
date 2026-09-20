module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

  // Method 1: continuous assign statement
  assign out_assign = a ^ b;

  // Method 2: combinational always block
  reg comb;
  always @(*) begin
    comb = a ^ b;
  end
  assign out_always_comb = comb;

  // Method 3: clocked always block (flip-flop, delayed output)
  reg ff;
  always @(posedge clk) begin
    ff <= a ^ b;
  end
  assign out_always_ff = ff;

endmodule
