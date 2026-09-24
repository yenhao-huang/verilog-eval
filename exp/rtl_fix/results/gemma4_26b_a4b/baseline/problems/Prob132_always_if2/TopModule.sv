module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Fix: Ensure shut_off_computer is assigned in all cases to avoid a latch.
    // If cpu_overheated is 1, shut_off_computer is 1. Otherwise, it is 0.
    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1'b1;
        else
            shut_off_computer = 1'b0;
    end

    // Fix: Ensure keep_driving is assigned in all cases to avoid a latch.
    // The driver keeps driving only if they haven't arrived AND the tank isn't empty.
    always @(*) begin
        if (~arrived && ~gas_tank_empty)
            keep_driving = 1'b1;
        else
            keep_driving = 1'b0;
    end

endmodule
