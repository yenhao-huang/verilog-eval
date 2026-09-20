module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

    // The JK flip-flop is a sequential element that updates on the rising edge of the clock.
    // We use a non-blocking assignment (<=) to ensure that the value of Q used in 
    // the logic is the value from the previous clock cycle (Qold).
    always @(posedge clk) begin
        case ({j, k})
            2'b00: Q <= Q;    // Hold: Q remains the same
            2'b01: Q <= 1'b0; // Reset: Q becomes 0
            2'b10: Q <= 1'b1; // Set: Q becomes 1
            2'b11: Q <= ~Q;   // Toggle: Q becomes the inverse of its previous state
            default: Q <= Q;  // Default case for safety
        endcase
    end

endmodule
