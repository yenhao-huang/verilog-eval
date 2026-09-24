module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    // The always block is sensitive to the positive edge of the clock 
    // and the positive edge of the asynchronous reset signal.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: when areset is high, output q is reset to 0.
            q <= 8'b0;
        end else begin
            // On the positive edge of clk, the value of d is captured by the DFFs.
            q <= d;
        end
    end

endmodule
