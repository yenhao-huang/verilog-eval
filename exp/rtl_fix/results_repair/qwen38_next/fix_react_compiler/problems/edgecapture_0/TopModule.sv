module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

    // previous value of in (was missing -> caused the "Unable to bind d_last" error)
    reg [31:0] d_last;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'd0;
        end
        else begin
            out <= out | (~in & d_last);   // capture 1 -> 0 transitions
        end
        d_last <= in;                      // remember current input for next cycle
    end

endmodule
