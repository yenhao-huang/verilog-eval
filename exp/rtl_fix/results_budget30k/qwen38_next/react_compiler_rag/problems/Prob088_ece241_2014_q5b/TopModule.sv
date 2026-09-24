module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state encoding
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (x) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    state <= B;
                end
                default: begin
                    state <= A;
                end
            endcase
        end
    end

    // Mealy output logic
    assign z = ((state == A) && x) || ((state == B) && ~x);

endmodule
