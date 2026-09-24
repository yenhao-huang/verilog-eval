module top_module(
	input clk,
	input reset,
	output shift_ena);

	// B0 -> B1 -> B2 -> B3 -> Done
	// B0: 1st shift cycle, B1: 2nd, B2: 3rd, B3: 4th, Done: finished

	reg [2:0] state;

	always @(posedge clk) begin
		if (reset) begin
			state <= 3'b000;      // B0
		end else begin
			case (state)
				3'b000:  state <= 3'b001;  // B0 -> B1
				3'b001:  state <= 3'b010;  // B1 -> B2
				3'b010:  state <= 3'b011;  // B2 -> B3
				3'b011:  state <= 3'b100;  // B3 -> Done
				default: state <= 3'b100;  // stay in Done forever
			endcase
		end
	end

	assign shift_ena = (state == 3'b000) || (state == 3'b001) ||
	                   (state == 3'b010) || (state == 3'b011);

endmodule
