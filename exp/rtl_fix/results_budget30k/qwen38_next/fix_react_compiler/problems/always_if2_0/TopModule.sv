module top_module (
	input cpu_overheated,
	output reg shut_off_computer,
	input arrived,
	input gas_tank_empty,
	output reg keep_driving
);

	// Combinational: no clock exists in this module's port list
	always @(*) begin
		if (cpu_overheated)
			shut_off_computer = 1'b1;
		else
			shut_off_computer = 1'b0;
	end

	// Combinational: keep driving only while not arrived and tank is not empty
	always @(*) begin
		if (~arrived)
			keep_driving = ~gas_tank_empty;
		else
			keep_driving = 1'b0;
	end

endmodule
