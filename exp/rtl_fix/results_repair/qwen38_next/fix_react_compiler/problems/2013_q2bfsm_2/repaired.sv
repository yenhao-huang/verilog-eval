module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

parameter A  = 4'd0;
parameter B  = 4'd1;
parameter S0 = 4'd2;
parameter S1 = 4'd3;
parameter S10= 4'd4;
parameter G1 = 4'd5;
parameter G2 = 4'd6;
parameter P0 = 4'd7;
parameter P1 = 4'd8;

reg  [3:0] state;
reg  [3:0] next_state;

// state register (synchronous, active-low reset)
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// next-state logic
always @(*) begin
    case (state)
        A:  next_state = B;                 // leave A one cycle after reset released
        B:  next_state = S0;                // f = 1 for exactly one cycle
        S0: next_state = x ? S1  : S0;      // looking for 1
        S1: next_state = x ? S1  : S10;     // got 1, looking for 0
        S10:next_state = x ? G1  : S0;      // 1,0,1 detected -> g = 1
        G1: next_state = y ? P1  : G2;      // check y (1st cycle)
        G2: next_state = y ? P1  : P0;      // check y (2nd cycle)
        P0: next_state = P0;                // g = 0 permanently
        P1: next_state = P1;                // g = 1 permanently
        default: next_state = A;
    endcase
end

// output logic (ports are wires -> continuous assignments)
assign f = (state == B);
assign g = (state == G1) || (state == G2) || (state == P1);

endmodule
