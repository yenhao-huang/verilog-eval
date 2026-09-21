module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding:
    // A = 0, output 0
    // B = 1, output 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
                default: state <= B;
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = state;

endmodule
