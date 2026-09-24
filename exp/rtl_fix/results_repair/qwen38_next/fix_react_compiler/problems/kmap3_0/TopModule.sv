module top_module (
	input a, 
	input b,
	input c,
	input d,
	output reg out
);

    // Combinational logic: no clock exists in this module's port list,
    // so use always @(*) instead of always @(posedge clk).
    always @(*) begin
        out = a | (~b & c);
    end

endmodule
