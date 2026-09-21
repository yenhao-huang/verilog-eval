module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    reg [7:0] q;

    // Negative-edge triggered DFFs with active-high synchronous reset
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;
        else
            q <= d;
    end

endmodule
