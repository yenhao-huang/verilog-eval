module top_module (
	input a, 
	input b,
	input c,
	input d,
	output reg out
);

  // Combinational logic (no clock exists in this module)
  // K-map simplification with don't-cares: out = a | (~b & c)
  always @(*) begin
    out = a | (~b & c);
  end

endmodule
