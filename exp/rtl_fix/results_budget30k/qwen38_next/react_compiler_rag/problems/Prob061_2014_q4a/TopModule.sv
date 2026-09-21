module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= R;        // parallel load
        end else if (E) begin
            Q <= w;        // shift enabled: take previous stage input
        end
        // otherwise hold current value
    end

endmodule
