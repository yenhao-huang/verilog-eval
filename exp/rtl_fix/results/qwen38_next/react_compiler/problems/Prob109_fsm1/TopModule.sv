module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A = 0, B = 1
    reg state;
    reg next_state;

    // Next-state logic (combinational)
    always @(*) begin
        if (state == 1'b0) begin
            // From A (0): in=0 -> B, in=1 -> A
            next_state = ~in;
        end else begin
            // From B (1): in=0 -> A, in=1 -> B
            next_state = in;
        end
    end

    // State register with asynchronous active-high reset into state B
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;
        end else begin
            state <= next_state;
        end
    end

    // Moore output: state A outputs 0, state B outputs 1
    assign out = state;

endmodule
