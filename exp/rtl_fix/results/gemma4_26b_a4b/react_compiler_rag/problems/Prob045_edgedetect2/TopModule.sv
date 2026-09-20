module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] in_reg;

    always @(posedge clk) begin
        in_reg <= in;
    end

    assign anyedge = in ^ in_reg;

endmodule
