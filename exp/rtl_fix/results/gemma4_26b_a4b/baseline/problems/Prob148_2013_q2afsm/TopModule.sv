module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    // STATE_A: Idle state, no device is granted access.
    // STATE_B: Device 0 is granted access (g[0]=1).
    // STATE_C: Device 1 is granted access (g[1]=1).
    // STATE_D: Device 2 is granted access (g[2]=1).
    localparam STATE_A = 2'b00,
               STATE_B = 2'b01,
               STATE_C = 2'b10,
               STATE_D = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // State Flip-Flops (Sequential Logic)
    // Triggered on the positive edge of the clock.
    // resetn is an active-low synchronous reset that resets the FSM to state A.
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    // State Table / Next State Logic (Combinational Logic)
    // Implements the priority-based arbitration logic.
    // Priority: Device 0 > Device 1 > Device 2.
    always @(*) begin
        case (state)
            STATE_A: begin
                if (r[0]) begin
                    // Device 0 has highest priority
                    next_state = STATE_B;
                end else if (r[1]) begin
                    // Device 1 has next priority
                    next_state = STATE_C;
                end else if (r[2]) begin
                    // Device 2 has lowest priority
                    next_state = STATE_D;
                end else begin
                    // No requests made
                    next_state = STATE_A;
                end
            end

            STATE_B: begin
                // Once device 0 is granted, it keeps the grant as long as r[0] is 1.
                if (r[0])
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_C: begin
                // Once device 1 is granted, it keeps the grant as long as r[1] is 1.
                if (r[1])
                    next_state = STATE_C;
                else
                    next_state = STATE_A;
            end

            STATE_D: begin
                // Once device 2 is granted, it keeps the grant as long as r[2] is 1.
                if (r[2])
                    next_state = STATE_D;
                else
                    next_state = STATE_A;
            end

            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // FSM Outputs (Continuous Assignment)
    // g[i] is set to 1 if the FSM is in the state corresponding to device i's grant.
    assign g[0] = (state == STATE_B);
    assign g[1] = (state == STATE_C);
    assign g[2] = (state == STATE_D);

endmodule
