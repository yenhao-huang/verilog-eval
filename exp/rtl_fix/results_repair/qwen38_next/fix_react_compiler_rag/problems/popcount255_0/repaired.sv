module top_module (
	input [254:0] in,
	output reg [7:0] out
);
	integer i;

	// Combinational population count: no clock exists in this module
	always @(*) begin
		out = 8'd0;                 // blocking assign, cleared each evaluation
		for (i = 0; i < 255; i = i + 1) begin
			out = out + in[i];      // accumulate the 1-bits
		end
	end
endmodule
