module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding: 1'b1 = B, 1'b0 = A
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // reset state is B
        end else begin
            case (state)
                1'b1: state <= in ? 1'b1 : 1'b0; // B: in=1 -> B, in=0 -> A
                1'b0: state <= in ? 1'b0 : 1'b1; // A: in=1 -> A, in=0 -> B
                default: state <= 1'b1;
            endcase
        end
    end

    // Moore output: out=1 in state B, out=0 in state A
    assign out = state;

endmodule
