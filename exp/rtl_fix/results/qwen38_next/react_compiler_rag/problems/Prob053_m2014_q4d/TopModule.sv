module TopModule (
  input  clk,
  input  in,
  output reg out
);

  // D flip-flop (no reset) whose D input is (in XOR out)
  always @(posedge clk) begin
    out <= in ^ out;
  end

endmodule
