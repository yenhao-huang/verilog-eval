module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

    // Missing declaration: remembers the value of "in" from the previous cycle
    reg [31:0] d_last;

    initial d_last = 32'd0;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'd0;
        end else begin
            // Sticky capture: set bits that had a 1 -> 0 transition
            out <= out | (~in & d_last);
        end
        // Delay register always tracks "in"
        d_last <= in;
    end

endmodule
