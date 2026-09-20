module top_module (
	input a, 
	input b,
	input c,
	input d,
	output reg out
);

    // K-map output is the XOR of all four inputs.
    // Combinational logic: no clock exists in this design,
    // so use a level-sensitive always block instead of @(posedge clk).
    always @(*) begin
        out = a ^ b ^ c ^ d;
    end

endmodule
