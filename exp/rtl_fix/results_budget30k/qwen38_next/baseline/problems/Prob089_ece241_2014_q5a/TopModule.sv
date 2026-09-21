module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // Moore states for serial 2's complement:
    // S_BEFORE: before the first '1' has been seen, output 0
    // S_ONE:    after first '1', output 1
    // S_ZERO:   after first '1', output 0
    localparam [1:0] S_BEFORE = 2'b00;
    localparam [1:0] S_ONE    = 2'b01;
    localparam [1:0] S_ZERO   = 2'b10;

    reg [1:0] state = S_BEFORE;
    reg [1:0] next_state;

    // State register with positive-edge asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S_BEFORE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            S_BEFORE: next_state = x ? S_ONE  : S_BEFORE;
            S_ONE:    next_state = x ? S_ZERO : S_ONE;
            S_ZERO:   next_state = x ? S_ZERO : S_ONE;
            default:  next_state = S_BEFORE;
        endcase
    end

    // Moore output depends only on state
    assign z = (state == S_ONE);

endmodule
