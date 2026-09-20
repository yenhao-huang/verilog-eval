module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_prev;

    initial begin
        in_prev = 8'h00;
        pedge   = 8'h00;
    end

    always @(posedge clk) begin
        in_prev <= in;
        pedge   <= in & ~in_prev;
    end

endmodule
