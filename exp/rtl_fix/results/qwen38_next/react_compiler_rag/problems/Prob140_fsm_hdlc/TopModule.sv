module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    localparam [3:0]
        A    = 4'd0, // 0 consecutive 1s (previous input treated as 0)
        B    = 4'd1, // 1 consecutive 1
        C    = 4'd2, // 2 consecutive 1s
        D    = 4'd3, // 3 consecutive 1s
        E    = 4'd4, // 4 consecutive 1s
        F    = 4'd5, // 5 consecutive 1s
        G    = 4'd6, // 6 consecutive 1s
        DISC = 4'd7, // saw 0111110 -> discard the inserted 0
        ERR  = 4'd8, // saw 7 or more consecutive 1s
        FLAG = 4'd9; // saw 01111110 -> frame boundary

    reg [3:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A:    next_state = in ? B    : A;
            B:    next_state = in ? C    : A;
            C:    next_state = in ? D    : A;
            D:    next_state = in ? E    : A;
            E:    next_state = in ? F    : A;
            F:    next_state = in ? G    : DISC;
            G:    next_state = in ? ERR  : FLAG;
            DISC: next_state = in ? B    : A;
            ERR:  next_state = in ? ERR  : A;
            FLAG: next_state = in ? B    : A;
            default: next_state = A;
        endcase
    end

    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err  = (state == ERR);

endmodule
