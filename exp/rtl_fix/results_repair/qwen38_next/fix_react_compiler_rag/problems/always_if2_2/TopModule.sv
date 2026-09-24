module top_module (
	input cpu_overheated,
	output reg shut_off_computer,
	input arrived,
	input gas_tank_empty,
	output reg keep_driving
);

    // Shut off the computer whenever the CPU is overheated
    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1'b1;
        else
            shut_off_computer = 1'b0;
    end

    // Keep driving while not arrived, as long as the gas tank isn't empty
    always @(*) begin
        if (arrived)
            keep_driving = 1'b0;
        else
            keep_driving = ~gas_tank_empty;
    end

endmodule
