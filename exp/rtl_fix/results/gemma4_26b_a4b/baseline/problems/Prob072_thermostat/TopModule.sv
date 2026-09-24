module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // The heater is turned on only in heating mode (mode = 1) 
    // when it is too cold (too_cold = 1).
    assign heater = mode && too_cold;

    // The air conditioner is turned on only in cooling mode (mode = 0) 
    // when it is too hot (too_hot = 1).
    assign aircon = (!mode) && too_hot;

    // The fan is turned on if:
    // 1. The heater is on
    // 2. The air conditioner is on
    // 3. The user manually requests the fan to be on (fan_on = 1)
    assign fan = heater || aircon || fan_on;

endmodule
