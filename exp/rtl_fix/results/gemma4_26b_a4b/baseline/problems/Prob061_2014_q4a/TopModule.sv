module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    // The module represents one stage of an n-bit shift register.
    // On the positive edge of the clock:
    // 1. If L (Load) is asserted, the register loads the value R.
    // 2. If L is not asserted but E (Enable Shift) is asserted, 
    //    the register shifts in the value w from the previous stage.
    // 3. Otherwise, the register maintains its current state.

    always @(posedge clk) begin
        if (L) begin
            Q <= R;
        end else if (E) begin
            Q <= w;
        end
        // Implicit else: Q <= Q;
    end

endmodule
