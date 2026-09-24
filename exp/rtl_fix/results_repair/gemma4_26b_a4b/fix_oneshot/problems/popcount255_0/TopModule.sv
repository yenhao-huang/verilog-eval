module top_module (
	input [254:0] in,
	output reg [7:0] out
);

	integer i;

	always @(*) begin
		// Initialize the output to 0 at the start of every evaluation
		out = 8'd0;
		// Iterate through all 255 bits of the input vector
		for (i = 0; i < 255; i = i + 1) begin
			// If the current bit is 1, increment the count
			if (in[i] == 1'b1) begin
				out = out + 1'b1;
			end
		end
	end

endmodule
