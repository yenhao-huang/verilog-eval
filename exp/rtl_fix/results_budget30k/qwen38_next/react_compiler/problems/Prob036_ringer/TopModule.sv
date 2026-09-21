module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // When ringing, use the motor in vibrate mode, otherwise use the ringer.
    // Both outputs are 0 when there is no incoming call, so they are never on together.
    assign ringer = ring & ~vibrate_mode;
    assign motor  = ring &  vibrate_mode;

endmodule
