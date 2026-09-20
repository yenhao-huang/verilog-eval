module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

    reg [3:0] q;

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 4'b0000;      // active-low, synchronous reset
        end else begin
            q <= {q[2:0], in}; // shift `in` through the four D flops
        end
    end

    assign out = q[3];         // output of the last flop

endmodule
