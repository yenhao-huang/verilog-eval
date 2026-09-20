module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    reg state;
    parameter A = 1'b0;
    parameter B = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: state <= in ? B : A;
                A: state <= in ? A : B;
                default: state <= B;
            endcase
        end
    end

    assign out = (state == B);
endmodule
