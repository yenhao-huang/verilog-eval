module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] in_d;

    always @(posedge clk) begin
        in_d <= in;
    end

    assign anyedge = in ^ in_d;

endmodule
