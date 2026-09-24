module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    // The module implements 8 D flip-flops by assigning the 8-bit 
    // input 'd' to the 8-bit register 'q' on every positive edge 
    // of the clock.
    always @(posedge clk) begin
        q <= d;
    end

endmodule
