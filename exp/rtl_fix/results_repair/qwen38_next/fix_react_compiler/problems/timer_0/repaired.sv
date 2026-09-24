module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output tc
);

	reg [9:0] counter = 10'd0;

	always @(posedge clk) begin
		if (load) begin
			counter <= data;              // load at any time, even mid-count
		end
		else if (counter != 10'd0) begin
			counter <= counter - 10'd1;   // decrement until 0, then hold at 0
		end
	end

	// tc is a wire (default output type), so drive it with a continuous assign
	assign tc = (counter == 10'd0);

endmodule
