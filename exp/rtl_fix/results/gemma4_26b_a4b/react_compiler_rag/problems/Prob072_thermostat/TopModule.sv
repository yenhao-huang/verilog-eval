module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);
    // In heating mode (mode = 1), turn the heater on when it is too cold (too_cold = 1).
    // In cooling mode (mode = 0), do not use the heater.
    assign heater = mode && too_cold;

    // In cooling mode (mode = 0), turn the air conditioner on when it is too hot (too_hot = 1).
    // In heating mode (mode = 1), do not use the air conditioner.
    assign aircon = !mode && too_hot;

    // When the heater or air conditioner are on, also turn on the fan to circulate the air.
    // Additionally, the user can request the fan to turn on (fan_on = 1).
    assign fan = heater || aircon || fan_on;
endmodule
