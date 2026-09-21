module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding: 1'b1 = B (out=1), 1'b0 = A (out=0)
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // synchronous reset to state B
        end else begin
            if (in) begin
                state <= state; // stay in current state
            end else begin
                state <= ~state; // toggle between A and B
            end
        end
    end

    assign out = state; // Moore output: B=1, A=0

endmodule
