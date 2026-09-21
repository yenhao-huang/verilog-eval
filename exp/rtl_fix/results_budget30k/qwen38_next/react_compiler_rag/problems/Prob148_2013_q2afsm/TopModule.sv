module TopModule (
    input  wire       clk,
    input  wire       resetn,
    input  wire [2:0] r,
    output wire [2:0] g
);

    // State encoding
    localparam [1:0] A = 2'd0,   // idle, no grant
                     B = 2'd1,   // grant device 0
                     C = 2'd2,   // grant device 1
                     D = 2'd3;   // grant device 2

    reg [1:0] state, next_state;

    // State flip-flops (synchronous active-low reset)
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // State table (next-state logic)
    always @(*) begin
        case (state)
            A: begin
                if (r[0])
                    next_state = B;          // device 0 has highest priority
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;          // no requests
            end
            B: next_state = r[0] ? B : A;    // keep grant while r0 = 1
            C: next_state = r[1] ? C : A;    // keep grant while r1 = 1
            D: next_state = r[2] ? D : A;    // keep grant while r2 = 1
            default: next_state = A;
        endcase
    end

    // Moore outputs
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule
