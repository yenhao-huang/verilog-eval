module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    // State encoding
    localparam [3:0] A = 4'd0,  // reset / beginning state
                     B = 4'd1,  // f = 1 for one clock cycle
                     C = 4'd2,  // waiting for first 1 of sequence 1,0,1
                     D = 4'd3,  // saw 1, waiting for 0
                     E = 4'd4,  // saw 1,0, waiting for 1
                     F = 4'd5,  // g = 1, monitor y (1st cycle)
                     G = 4'd6,  // g = 1 permanently
                     H = 4'd7,  // g = 1, monitor y (2nd cycle)
                     I = 4'd8;  // g = 0 permanently

    reg [3:0] state, next_state;

    // state register with synchronous, active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // next state logic
    always @(*) begin
        case (state)
            A:       next_state = B;             // leave reset state
            B:       next_state = C;             // f was high for one cycle
            C:       next_state = x ? D : C;     // look for first 1
            D:       next_state = x ? D : E;     // stay anchored on repeated 1s
            E:       next_state = x ? F : C;     // completed 1,0,1 -> g=1
            F:       next_state = y ? G : H;     // 1st y check
            G:       next_state = G;             // g stuck at 1
            H:       next_state = y ? G : I;     // 2nd y check
            I:       next_state = I;             // g stuck at 0
            default: next_state = A;
        endcase
    end

    // output logic
    assign f = (state == B);
    assign g = (state == F) || (state == G) || (state == H);

endmodule
