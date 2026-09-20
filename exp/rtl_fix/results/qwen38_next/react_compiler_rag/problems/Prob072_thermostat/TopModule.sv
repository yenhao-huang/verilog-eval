module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    // Heating mode (mode = 1): heater on when too cold
    assign heater = mode & too_cold;

    // Cooling mode (mode = 0): air conditioner on when too hot
    assign aircon = ~mode & too_hot;

    // Fan runs whenever heater or aircon is on, or user requests it
    assign fan    = heater | aircon | fan_on;

endmodule
