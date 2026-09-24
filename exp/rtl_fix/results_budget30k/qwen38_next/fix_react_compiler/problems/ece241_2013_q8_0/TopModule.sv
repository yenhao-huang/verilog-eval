module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

// State encoding: the missing declarations that caused the "Unable to bind" errors
localparam S   = 2'd0;   // no part of "101" seen
localparam S1  = 2'd1;   // seen "1"
localparam S10 = 2'd2;   // seen "10"

reg [1:0] state, next_state;   // 3 states require >= 2 bits

// State register: negative-edge asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn)
        state <= S;
    else
        state <= next_state;
end

// Next-state and Mealy output logic (blocking assignments)
always @(state, x) begin
    case (state)
        S: begin
            if (x == 1'b0) next_state = S;
            else           next_state = S1;
            z = 1'b0;
        end
        S1: begin
            if (x == 1'b0) next_state = S10;
            else           next_state = S1;
            z = 1'b0;
        end
        S10: begin
            if (x == 1'b0) next_state = S;
            else           next_state = S1;   // overlap: trailing '1' starts a new "101"
            z = x;                            // "101" detected -> z = 1
        end
        default: begin
            next_state = S;
            z = 1'b0;
        end
    endcase
end

endmodule
