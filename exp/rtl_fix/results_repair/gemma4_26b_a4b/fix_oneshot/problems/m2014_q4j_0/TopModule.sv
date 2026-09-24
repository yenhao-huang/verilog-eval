module top_module (
	input [3:0] x,
	input [3:0] y,
	output logic [4:0] sum
);

always_comb
	begin
		sum = x + y;
	end

endmodule
