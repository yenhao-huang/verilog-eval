module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    localparam [1:0] A = 2'd0,
                     B = 2'd1,
                     C = 2'd2,
                     D = 2'd3;

    reg [1:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output: asserted only in state D
    assign out = (state == D);

endmodule
