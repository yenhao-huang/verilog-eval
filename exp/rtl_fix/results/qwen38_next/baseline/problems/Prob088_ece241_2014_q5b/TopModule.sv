module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot encoding
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg  [1:0] state;
    wire [1:0] next_state;

    // Sequential state register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // Mealy output logic
    assign z = ((state == A) &&  x) ||
               ((state == B) && !x);

endmodule
