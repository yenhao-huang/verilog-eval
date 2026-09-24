module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // 2's complement: pass bits through unchanged up to and including
    // the first 1 (LSB-first), then invert all remaining bits.
    localparam [1:0] S0 = 2'd0; // haven't seen first 1 yet -> z = 0
    localparam [1:0] S1 = 2'd1; // seen first 1 / inverting, x was 0 -> z = 1
    localparam [1:0] S2 = 2'd2; // seen first 1 / inverting, x was 1 -> z = 0

    reg [1:0] state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S2 : S1;
                S2: state <= x ? S2 : S1;
                default: state <= S0;
            endcase
    end

    // Moore output: depends only on the current state
    assign z = (state == S1);

endmodule
