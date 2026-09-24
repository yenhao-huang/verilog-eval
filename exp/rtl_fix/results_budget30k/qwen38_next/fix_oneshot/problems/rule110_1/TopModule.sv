module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left;
    wire [511:0] right;

    assign left  = {q[510:0], 1'b0};
    assign right = {1'b0, q[511:1]};

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= (~left & (q | right)) | (left & (q ^ right));
    end

endmodule
