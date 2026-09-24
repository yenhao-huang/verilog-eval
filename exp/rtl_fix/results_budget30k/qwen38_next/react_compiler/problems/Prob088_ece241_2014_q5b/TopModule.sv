module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot encoding
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Mealy output logic
    // State A: z = x  (x=0 -> z=0, x=1 -> z=1)
    // State B: z = ~x (x=0 -> z=1, x=1 -> z=0)
    assign z = (state == A) ? x : ~x;

endmodule
