module top_module (
	input [3:0] in,
	output reg [1:0] pos
);

// A priority encoder is a combinational circuit.
// The erroneous implementation used a clock (clk) which was not defined,
// and it treated the circuit as sequential (always @ posedge clk).
// For a combinational circuit, we use always @ (*).

always @ (*) begin
	if (in[0]) begin
		pos = 2'd0;
	end else if (in[1]) begin
		pos = 2'd1;
	end else if (in[2]) begin
		pos = 2'd2;
	end else if (in[3]) begin
		pos = 2'd3;
	end else begin
		// If none of the input bits are high, output zero.
		pos = 2'd0;
	end
end

endmodule
