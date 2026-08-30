module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic in,
    output logic out
);

    logic state; // 0 = A, 1 = B

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Reset to state B
        end else begin
            if (in) begin
                state <= state; // Stay in current state
            end else begin
                state <= ~state; // Toggle between A and B
            end
        end
    end

    assign out = state; // Moore output: A=0, B=1

endmodule
