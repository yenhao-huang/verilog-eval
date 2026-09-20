module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_prev <= 32'b0;
        end else begin
            in_prev <= in;
            // Capture when the input signal changes from 1 to 0.
            // (~in & in_prev) detects the falling edge for each bit.
            // Once captured, the output bit remains 1 due to the OR operation.
            out <= out | (~in & in_prev);
        end
    end

endmodule
