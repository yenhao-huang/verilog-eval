module TopModule (
    input  clk,
    input  in,
    output reg out
);

    // D flip-flop (no reset) whose D input is the XOR of 'in' and the
    // current flip-flop output 'out'.
    initial out = 1'b0;

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule
