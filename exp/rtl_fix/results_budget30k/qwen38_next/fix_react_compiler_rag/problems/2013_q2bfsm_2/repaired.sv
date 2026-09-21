module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

    parameter A  = 3'd0;
    parameter B  = 3'd1;
    parameter S0 = 3'd2;
    parameter S1 = 3'd3;
    parameter S10= 3'd4;
    parameter G1 = 3'd5;
    parameter G2 = 3'd6;
    parameter P0 = 3'd7;
    parameter P1 = 3'd8;

    reg [3:0] current_state, next_state;

    // state register : synchronous, active-low reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // next state logic
    always @(*) begin
        case (current_state)
            A:    next_state = B;                       // after reset de-asserted, f = 1 for one cycle
            B:    next_state = S0;
            S0:   next_state = x ? S1  : S0;            // looking for first 1
            S1:   next_state = x ? S1  : S10;           // looking for 0
            S10:  next_state = x ? G1  : S0;            // looking for second 1
            G1:   next_state = y ? P1  : G2;            // y within 1 cycle
            G2:   next_state = y ? P1  : P0;            // y within 2 cycles
            P0:   next_state = P0;                      // g = 0 permanently
            P1:   next_state = P1;                      // g = 1 permanently
            default: next_state = A;
        endcase
    end

    // output logic : f and g are wires in the given module header,
    // so they must be driven with continuous assignments, not procedural ones.
    assign f = (current_state == B);
    assign g = (current_state == G1) || (current_state == G2) || (current_state == P1);

endmodule
