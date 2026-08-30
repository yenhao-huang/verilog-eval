module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule
