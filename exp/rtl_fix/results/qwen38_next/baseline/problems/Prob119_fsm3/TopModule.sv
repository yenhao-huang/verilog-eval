module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam [1:0] A = 2'd0;
    localparam [1:0] B = 2'd1;
    localparam [1:0] C = 2'd2;
    localparam [1:0] D = 2'd3;

    reg [1:0] state;
    reg [1:0] next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output logic
    assign out = (state == D);

endmodule
