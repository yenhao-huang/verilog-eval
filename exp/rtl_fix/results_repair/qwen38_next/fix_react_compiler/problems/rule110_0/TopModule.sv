module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    // left neighbor of q[i] is q[i+1], with q[512] = 0
    // right neighbor of q[i] is q[i-1], with q[-1] = 0
    wire [511:0] left;
    wire [511:0] right;

    assign left  = {1'b0, q[511:1]};
    assign right = {q[510:0], 1'b0};

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
        else begin
            // Rule 110: next state is 0 only for 111, 100, 000
            q <= ~((left & q & right) |
                   (~left & ~q & ~right) |
                   (left & ~q & ~right));
        end
    end
endmodule
