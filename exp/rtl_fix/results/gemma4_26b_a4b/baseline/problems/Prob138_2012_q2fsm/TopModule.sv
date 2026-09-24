module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding using localparam
    // We have 6 states, so 3 bits are required.
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    reg [2:0] state;
    reg [2:0] next_state;

    // State flip-flops: Sequential logic triggered on the positive edge of the clock.
    // Reset is synchronous and active-high, resetting the machine to state A.
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // State table: Combinational logic to determine the next state based on current state and input w.
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // FSM output logic: 
    // Based on the provided state machine notation:
    // States A, B, C, D have output z = 0.
    // States E, F have output z = 1.
    assign z = (state == E || state == F);

endmodule
