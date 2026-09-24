module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    localparam [1:0] A = 2'd0; // reset / no useful prefix
    localparam [1:0] B = 2'd1; // saw 1
    localparam [1:0] C = 2'd2; // saw 10

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = x ? B : C;
            C: next_state = x ? B : A;
            default: next_state = A;
        endcase
    end

    assign z = (state == C) && x;

endmodule
