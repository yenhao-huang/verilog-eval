module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode (mode = 1): heater on when too cold
    assign heater = mode & too_cold;

    // Cooling mode (mode = 0): air conditioner on when too hot
    assign aircon = ~mode & too_hot;

    // Fan runs whenever heater/aircon are on, or the user requests it
    assign fan = fan_on | heater | aircon;

endmodule
