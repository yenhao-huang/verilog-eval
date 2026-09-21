module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev = 8'h00;
    reg [7:0] pedge_r = 8'h00;

    always @(posedge clk) begin
        prev <= in;
        pedge_r <= in & ~prev;
    end

    assign pedge = pedge_r;

endmodule
