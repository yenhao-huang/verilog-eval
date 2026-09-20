module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // 2's complement rule (LSB first): copy all bits up to and including
    // the first '1', then invert all remaining bits.
    localparam [1:0] S_WAIT = 2'd0,  // no '1' seen yet  -> z = 0
                     S_ONE  = 2'd1,  // emit 1            -> z = 1
                     S_ZERO = 2'd2;  // emit 0 (inverted) -> z = 0

    reg [1:0] state, next_state;

    // state register with positive-edge asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S_WAIT;
        else
            state <= next_state;
    end

    // next-state logic
    always @(*) begin
        case (state)
            S_WAIT: next_state = x ? S_ONE  : S_WAIT; // pass the first 1 through
            S_ONE:  next_state = x ? S_ZERO : S_ONE;  // invert afterwards
            S_ZERO: next_state = x ? S_ZERO : S_ONE;
            default: next_state = S_WAIT;
        endcase
    end

    // Moore output
    assign z = (state == S_ONE);

endmodule
