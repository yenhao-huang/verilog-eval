module top_module (
	input clk,
	input in,
	input reset,
	output reg out
);

	// State encoding
	localparam A = 2'b00;
	localparam B = 2'b01;
	localparam C = 2'b10;
	localparam D = 2'b11;

	reg [1:0] state;

	// State transition logic
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

	// Output logic (Moore machine: output depends only on the current state)
	always @* begin
		if (state == D) begin
			out = 1'b1;
		end
		else begin
			out = 1'b0;
		end
	end

endmodule
