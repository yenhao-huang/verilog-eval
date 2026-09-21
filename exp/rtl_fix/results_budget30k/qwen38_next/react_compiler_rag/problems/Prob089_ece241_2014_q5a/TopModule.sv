module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    localparam [1:0] S0 = 2'b00; // no 1 seen yet, z = 0
    localparam [1:0] S1 = 2'b01; // at least one 1 seen, z = 1
    localparam [1:0] S2 = 2'b10; // at least one 1 seen, z = 0

    reg [1:0] state;
    reg [1:0] next_state;

    // State register with positive-edge-triggered asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            S0:      next_state = x ? S1 : S0;
            S1:      next_state = x ? S2 : S1;
            S2:      next_state = x ? S2 : S1;
            default: next_state = S0;
        endcase
    end

    // Moore output logic
    assign z = (state == S1);

endmodule
