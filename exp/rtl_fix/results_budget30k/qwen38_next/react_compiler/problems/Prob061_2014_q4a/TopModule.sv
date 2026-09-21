module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output Q
);

    reg q;

    always @(posedge clk) begin
        if (L)
            q <= R;        // load the parallel input value
        else if (E)
            q <= w;        // shift: take value from previous stage
    end

    assign Q = q;

endmodule
