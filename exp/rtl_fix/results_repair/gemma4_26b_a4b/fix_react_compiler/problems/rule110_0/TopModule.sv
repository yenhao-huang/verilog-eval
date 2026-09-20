module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    wire [511:0] L = {1'b0, q[511:1]};
    wire [511:0] R = {q[510:0], 1'b0};

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= (~L & q) | (~q & R) | (L & q & ~R);
        end
    end

endmodule
