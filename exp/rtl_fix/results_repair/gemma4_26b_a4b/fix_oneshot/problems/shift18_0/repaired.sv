module top_module(
	input clk,
	input load,
	input ena,
	input [1:0] amount,
	input [63:0] data,
	output reg [63:0] q);

always @(posedge clk) begin
	if (load) begin
		// Synchronous load takes precedence
		q <= data;
	end else if (ena) begin
		// Shift only if enabled and not loading
		case (amount)
			2'b00: begin
				// Shift left by 1 bit
				q <= {q[62:0], 1'b0};
			end
			2'b01: begin
				// Shift left by 8 bits
				q <= {q[55:0], 8'b0};
			end
			2'b10: begin
				// Arithmetic shift right by 1 bit (preserve sign bit)
				q <= {q[63], q[63:1]};
			end
			2'b11: begin
				// Arithmetic shift right by 8 bits (preserve sign bit)
				// The syntax error in the original was the missing braces around the replication
				q <= {{8{q[63]}}, q[63:8]};
			end
			default: begin
				q <= q;
			end
		endcase
	end
end

endmodule
