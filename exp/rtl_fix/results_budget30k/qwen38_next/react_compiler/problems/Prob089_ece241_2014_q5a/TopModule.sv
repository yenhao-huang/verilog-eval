module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    localparam [1:0] A = 2'd0; // before first 1, z=0
    localparam [1:0] B = 2'd1; // output bit is 1
    localparam [1:0] C = 2'd2; // output bit is 0

    reg [1:0] state, next_state;

    // State register with positive-edge-triggered asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = x ? C : B;
            C: next_state = x ? C : B;
            default: next_state = A;
        endcase
    end

    // Moore output: depends only on the state
    assign z = (state == B);

endmodule
