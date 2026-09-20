module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    /*
     * The module processes a 16-bit scancode input.
     * Based on the provided mapping, it asserts one of the four arrow key 
     * outputs if the scancode matches a specific value.
     * 
     * Since no clock signal is provided in the module interface, 
     * this is implemented as combinational logic.
     */

    always @(*) begin
        // Default all outputs to 0 to ensure no latches are inferred 
        // and to handle the "Anything else | none" requirement.
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        case (scancode)
            16'he06b: left  = 1'b1; // left arrow
            16'he072: down  = 1'b1; // down arrow
            16'he074: right = 1'b1; // right arrow
            16'he075: up    = 1'b1; // up arrow
            default: ;              // All outputs remain 0
        endcase
    end

endmodule
