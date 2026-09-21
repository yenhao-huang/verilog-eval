module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
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
    assign z = (state[0] & x) | (state[1] & ~x);

endmodule
