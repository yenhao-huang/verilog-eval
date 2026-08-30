module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);

    reg [3:0] q;

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 4'b0000;
        end else begin
            q <= {q[2:0], in};
        end
    end

    assign out = q[3];

endmodule
