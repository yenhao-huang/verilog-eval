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
            state <= 1'b1;      // synchronous active-high reset -> state B
        end else begin
            if (!in)
                state <= ~state; // in=0: B<->A
            else
                state <= state;  // in=1: stay in current state
        end
    end

    // Moore output: out=1 in state B, out=0 in state A
    assign out = state;

endmodule
