module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // state encoding: 1'b1 = B (out=1), 1'b0 = A (out=0)
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b1;      // synchronous, active-high reset -> state B
        else if (!in)
            state <= ~state;    // in=0: A<->B (toggle)
        else
            state <= state;     // in=1: stay in current state
    end

    assign out = state;         // Moore output depends only on state

endmodule
