module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] L, R, C;
    assign C = q;
    assign L = {q[511:1], 1'b0};
    assign R = {1'b0, q[510:0]};

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= (C ^ R) | (~L & R);
        end
    end

endmodule
