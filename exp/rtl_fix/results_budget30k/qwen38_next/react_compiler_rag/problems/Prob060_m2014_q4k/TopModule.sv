module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] q;

    always @(posedge clk) begin
        if (!resetn)
            q <= 4'b0;          // active-low synchronous reset
        else
            q <= {q[2:0], in};  // shift in from the left
    end

    assign out = q[3];

endmodule
