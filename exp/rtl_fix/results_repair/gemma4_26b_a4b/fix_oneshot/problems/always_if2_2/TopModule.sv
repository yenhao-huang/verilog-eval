module top_module (
	input cpu_overheated,
	output reg shut_off_computer,
	input arrived,
	input gas_tank_empty,
	output reg keep_driving
);

	// The erroneous implementation used 'always @(posedge clk)', but 'clk' was not defined in the module ports.
	// Based on the problem description and the provided module signature, the logic should be combinational.
	// To avoid latches, we must ensure all paths in the 'always @(*)' blocks assign a value to the outputs.

	always @(*) begin
		if (cpu_overheated) begin
			shut_off_computer = 1'b1;
		end else begin
			shut_off_computer = 1'b0;
		end
	end

	always @(*) begin
		if (arrived) begin
			keep_driving = 1'b0;
		end else begin
			keep_driving = ~gas_tank_empty;
		end
	end

endmodule
