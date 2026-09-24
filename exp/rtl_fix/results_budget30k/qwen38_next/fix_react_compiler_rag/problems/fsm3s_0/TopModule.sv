module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	// State encoding (must be declared - this was the missing part)
	localparam [1:0] A = 2'b00;
	localparam [1:0] B = 2'b01;
	localparam [1:0] C = 2'b10;
	localparam [1:0] D = 2'b11;

	// State register (must be declared - this was the missing part)
	reg [1:0] state;

	// State register / next-state logic with synchronous active-high reset
	always @(posedge clk) begin
		if (reset) begin
			state <= A;
		end
		else begin
			case (state)
				A: state <= in ? B : A;
				B: state <= in ? B : C;
				C: state <= in ? D : A;
				D: state <= in ? B : C;
				default: state <= A;
			endcase
		end
	end

	// Moore output: asserted only in state D
	assign out = (state == D);

endmodule
