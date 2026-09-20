module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding
    localparam [2:0] A = 3'd0;
    localparam [2:0] B = 3'd1;
    localparam [2:0] C = 3'd2;
    localparam [2:0] D = 3'd3;
    localparam [2:0] E = 3'd4;
    localparam [2:0] F = 3'd5;

    reg [2:0] state;
    reg [2:0] next_state;

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // State table / next-state logic
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // FSM output
    assign z = (state == E) || (state == F);

endmodule
