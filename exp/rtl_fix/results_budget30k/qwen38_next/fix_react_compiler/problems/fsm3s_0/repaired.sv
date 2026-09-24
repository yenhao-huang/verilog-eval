module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	reg out;
	reg [1:0] state;

	localparam [1:0] A = 2'd0;
	localparam [1:0] B = 2'd1;
	localparam [1:0] C = 2'd2;
	localparam [1:0] D = 2'd3;

	always @(posedge clk) begin
		if (reset) begin
			state <= A;
		end
		else begin
			case (state)
				A: begin
					if (in) begin
						state <= B;
					end
					else begin
						state <= A;
					end
				end
				B: begin
					if (in) begin
						state <= B;
					end
					else begin
						state <= C;
					end
				end
				C: begin
					if (in) begin
						state <= D;
					end
					else begin
						state <= A;
					end
				end
				D: begin
					if (in) begin
						state <= B;
					end
					else begin
						state <= C;
					end
				end
				default: begin
					state <= A;
				end
			endcase
		end
	end

	always @* begin
		if (state == D) begin
			out <= 1'b1;
		end
		else begin
			out <= 1'b0;
		end
	end

endmodule
