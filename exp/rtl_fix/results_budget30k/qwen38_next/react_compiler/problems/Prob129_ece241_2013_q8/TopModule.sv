module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output wire z
);

    localparam [1:0] S_A = 2'd0; // no useful prefix
    localparam [1:0] S_B = 2'd1; // seen "1"
    localparam [1:0] S_C = 2'd2; // seen "10"

    reg [1:0] state;
    reg [1:0] next_state;

    // State register with negative-edge asynchronous (active-low) reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            S_A: next_state = x ? S_B : S_A;   // "1" -> seen 1
            S_B: next_state = x ? S_B : S_C;   // "10" -> seen 10; "11" -> still seen 1
            S_C: next_state = x ? S_B : S_A;   // "101" -> overlap: trailing 1 starts new match
            default: next_state = S_A;
        endcase
    end

    // Mealy output: assert z when in "10" state and x = 1
    assign z = (state == S_C) && x;

endmodule
