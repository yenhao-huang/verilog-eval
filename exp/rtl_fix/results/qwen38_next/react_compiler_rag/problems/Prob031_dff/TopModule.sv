module TopModule (
    input  clk,
    input  d,
    output reg q
);

    // Single D flip-flop: capture d into q on the rising edge of clk
    always @(posedge clk) begin
        q <= d;
    end

endmodule
