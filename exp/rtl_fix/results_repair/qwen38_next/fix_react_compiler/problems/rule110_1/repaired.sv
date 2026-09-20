module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    // Neighbours with zero (off) boundaries: q[-1] = 0 and q[512] = 0
    wire [511:0] left  = {q[510:0], 1'b0};   // left[i]  = q[i-1], left[0]  = 0
    wire [511:0] right = {1'b0, q[511:1]};   // right[i] = q[i+1], right[511] = 0

    // Rule 110: next = 0 only for 111, 100, 000
    wire [511:0] next = (~q & right) | (q & ~(left & right));

    always @(posedge clk) begin
        if (load)
            q <= data;      // synchronous active-high load
        else
            q <= next;      // advance automaton one time step
    end

endmodule
