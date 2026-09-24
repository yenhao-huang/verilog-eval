module top_module (
	input [3:0] a, 
	input [3:0] b, 
	input [3:0] c, 
	input [3:0] d,
	input [3:0] e,
	output reg [3:0] q
);

// The circuit is combinational, so we use always @(*) instead of always @(posedge clk).
// Based on the simulation waveform:
// c = 0 -> q = b
// c = 1 -> q = e
// c = 2 -> q = a
// c = 3 -> q = d
// c >= 4 -> q = 4'hf (represented as 'f' in the waveform)

always @(*) 
begin
	if (c == 4'd0) 
		q = b;
	else if (c == 4'd1) 
		q = e;
	else if (c == 4'd2) 
		q = a;
	else if (c == 4'd3) 
		q = d;
	else 
		q = 4'hf;
end

endmodule
