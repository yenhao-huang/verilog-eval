module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	integer i;
	reg [2:0] pattern;

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			for (i = 0; i < 512; i = i + 1) begin
				if (i == 0)
					pattern = {1'b0, q[i], q[i+1]};      // q[-1] = 0
				else if (i == 511)
					pattern = {q[i-1], q[i], 1'b0};      // q[512] = 0
				else
					pattern = {q[i-1], q[i], q[i+1]};

				// Rule 110: next = 1 for patterns 001,010,011,101,110
				case (pattern)
					3'b001, 3'b010, 3'b011, 3'b101, 3'b110:
						q[i] <= 1'b1;
					default:
						q[i] <= 1'b0;                    // 000 and 111 -> 0
				endcase
			end
		end
	end

endmodule
