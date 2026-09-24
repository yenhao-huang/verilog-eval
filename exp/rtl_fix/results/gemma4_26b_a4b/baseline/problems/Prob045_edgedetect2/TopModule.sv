module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Internal register to store the state of the input from the previous clock cycle
    reg [7:0] in_prev;

    // Sequential logic triggered on the positive edge of the clock
    always @(posedge clk) begin
        // Store the current input value to be used as 'previous' in the next cycle
        in_prev <= in;
        
        // Detect any edge by XORing the current input with the previous input.
        // An XOR operation returns 1 if the bits are different (0 to 1 or 1 to 0).
        // Because we use non-blocking assignments (<=), 'anyedge' is updated 
        // using the values of 'in' and 'in_prev' from the previous clock cycle.
        // This ensures that the output is set to 1 in the cycle after the transition is detected.
        anyedge <= in ^ in_prev;
    end

endmodule
