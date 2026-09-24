module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    wire [511:0] left;
    wire [511:0] right;
    wire [511:0] next_q;

    // q[511] is the leftmost cell:
    //   left neighbor  of q[i] is q[i+1], with boundary q[512] = 0
    //   right neighbor of q[i] is q[i-1], with boundary q[-1]  = 0
    assign left  = {1'b0, q[511:1]};
    assign right = {q[510:0], 1'b0};

    // Rule 110 truth table (L C R -> next):
    // 111->0 110->1 101->1 100->0 011->1 010->1 001->1 000->0
    // simplifies to: next = (C & ~(L & R)) | (~C & R)
    assign next_q = (q & ~(left & right)) | (~q & right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
