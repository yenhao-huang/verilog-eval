module top_module (
	input [254:0] in,
	output reg [7:0] out
);

	integer i;

	always @(*) begin
		out = 8'd0;                       // blocking assignment, accumulate correctly
		for (i = 0; i < 255; i = i + 1) begin
			if (in[i] == 1'b1) begin
				out = out + 8'd1;
			end
		end
	end

endmodule
