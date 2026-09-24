module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    localparam [3:0] A    = 4'd0;  // beginning state (reset)
    localparam [3:0] B    = 4'd1;  // f = 1 for one clock cycle
    localparam [3:0] C    = 4'd2;  // waiting for x = 1
    localparam [3:0] D    = 4'd3;  // saw 1, waiting for x = 0
    localparam [3:0] E    = 4'd4;  // saw 1,0, waiting for x = 1
    localparam [3:0] G    = 4'd5;  // g = 1, checking y (1st cycle)
    localparam [3:0] H    = 4'd6;  // g = 1, checking y (2nd cycle)
    localparam [3:0] S    = 4'd7;  // g = 1 permanently
    localparam [3:0] FAIL = 4'd8;  // g = 0 permanently

    reg [3:0] state, next_state;

    initial state = A;

    // Synchronous, active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            A:    next_state = B;                 // reset released -> pulse f
            B:    next_state = C;                 // one cycle of f = 1
            C:    next_state = x ? D : C;         // detect 1
            D:    next_state = x ? D : E;         // detect 0 (stay on 1s)
            E:    next_state = x ? G : C;         // detect 1 -> g = 1
            G:    next_state = y ? S : H;         // y in 1st cycle
            H:    next_state = y ? S : FAIL;      // y in 2nd cycle
            S:    next_state = S;                 // g = 1 permanently
            FAIL: next_state = FAIL;              // g = 0 permanently
            default: next_state = A;
        endcase
    end

    // Outputs (Moore)
    assign f = (state == B);
    assign g = (state == G) || (state == H) || (state == S);

endmodule
