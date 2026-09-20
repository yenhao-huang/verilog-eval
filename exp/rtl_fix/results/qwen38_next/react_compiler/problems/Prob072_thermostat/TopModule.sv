module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode (mode = 1): heater on when too cold, AC never on.
    assign heater = mode & too_cold;

    // Cooling mode (mode = 0): AC on when too hot, heater never on.
    assign aircon = ~mode & too_hot;

    // Fan runs whenever heater/AC run, or when the user requests it.
    assign fan = fan_on | heater | aircon;

endmodule
