module TopModule (
  input  clk,
  input  a,
  output q
);

  reg d0;
  reg d1;

  always @(posedge clk) begin
    d0 <= a;
    d1 <= d0;
  end

  assign q = ~d1;

endmodule
