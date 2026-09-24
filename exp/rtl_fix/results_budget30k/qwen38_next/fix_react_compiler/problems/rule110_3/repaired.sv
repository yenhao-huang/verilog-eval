module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    // Neighbour vectors, with zero-padded boundaries:
    //   left[i]  = q[i+1], and left[511]  = q[512] = 0
    //   right[i] = q[i-1], and right[0]   = q[-1]  = 0
    wire [511:0] left  = {1'b0, q[511:1]};
    wire [511:0] right = {q[510:0], 1'b0};

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
        else begin
            // Rule 110: next = (L & (C ^ R)) | (~L & (C | R))
            q <= (left & (q ^ right)) | (~left & (q | right));
        end
    end

endmodule
