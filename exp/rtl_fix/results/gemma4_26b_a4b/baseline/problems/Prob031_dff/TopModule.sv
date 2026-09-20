module TopModule (
    input clk,
    input d,
    output reg q
);

    // The module implements a single D flip-flop.
    // On the positive edge of the clock, the value of the input 'd' 
    // is captured and assigned to the output 'q'.
    always @(posedge clk) begin
        q <= d;
    end

endmodule
