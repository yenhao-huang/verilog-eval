module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // The ringer should be active only if there is an incoming call (ring)
    // AND the phone is NOT in vibrate mode.
    assign ringer = ring & (~vibrate_mode);

    // The motor should be active only if there is an incoming call (ring)
    // AND the phone IS in vibrate mode.
    assign motor = ring & vibrate_mode;

endmodule
