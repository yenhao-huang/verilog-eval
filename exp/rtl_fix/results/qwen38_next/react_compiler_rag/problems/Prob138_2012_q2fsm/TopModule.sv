module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    localparam [2:0] A = 3'd0,
                     B = 3'd1,
                     C = 3'd2,
                     D = 3'd3,
                     E = 3'd4,
                     F = 3'd5;

    reg [2:0] state_reg, state_next;

    // state flip-flops (synchronous active-high reset to A)
    always @(posedge clk) begin
        if (reset)
            state_reg <= A;
        else
            state_reg <= state_next;
    end

    // state table (next-state logic)
    always @(*) begin
        case (state_reg)
            A: state_next = w ? B : A;
            B: state_next = w ? C : D;
            C: state_next = w ? E : D;
            D: state_next = w ? F : A;
            E: state_next = w ? E : D;
            F: state_next = w ? C : D;
            default: state_next = A;
        endcase
    end

    // FSM output: z = 1 in states E and F (Moore output)
    assign z = (state_reg == E) || (state_reg == F);

endmodule
