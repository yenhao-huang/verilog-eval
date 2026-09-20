module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode: mode = 1
    // Cooling mode: mode = 0
    assign heater = mode & too_cold;
    assign aircon = (~mode) & too_hot;

    // Fan runs if heater/aircon are on, or if user requests it
    assign fan = fan_on | heater | aircon;

endmodule
