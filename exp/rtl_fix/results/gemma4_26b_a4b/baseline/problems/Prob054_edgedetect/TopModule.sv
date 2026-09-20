module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // Internal register to store the state of the input from the previous clock cycle
    reg [7:0] in_prev;

    always @(posedge clk) begin
        // Store the current input value to be used as 'previous' in the next cycle
        in_prev <= in;

        // Detect a positive edge: 
        // A bit is 1 in the current cycle (in) AND was 0 in the previous cycle (~in_prev).
        // Because we use non-blocking assignments, 'pedge' will be updated based on 
        // the values of 'in' and 'in_prev' as they existed at the start of the clock edge.
        //
        // Timing Trace:
        // T=0: in=0, in_prev=0, pedge=0
        // T=1: in=1 (Transition occurs)
        //      At edge T=1: in_prev becomes 0 (the old value of in).
        //      At edge T=2: pedge becomes (in & ~in_prev) -> (1 & ~0) = 1.
        // This ensures the output is set the cycle after the transition occurs.
        pedge <= in & ~in_prev;
    end

endmodule
