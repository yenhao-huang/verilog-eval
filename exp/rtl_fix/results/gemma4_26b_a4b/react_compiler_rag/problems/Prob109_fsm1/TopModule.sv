module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;
    parameter B = 1'b1;
    parameter A = 1'b0;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            if (state == B) begin
                if (in == 1'b0)
                    state <= A;
                else
                    state <= B;
            end else begin
                if (in == 1'b0)
                    state <= B;
                else
                    state <= A;
            end
        end
    end

    assign out = state;

endmodule
