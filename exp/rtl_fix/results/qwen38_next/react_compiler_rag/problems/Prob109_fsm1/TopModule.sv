module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding: 1'b0 = A (output 0), 1'b1 = B (output 1)
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Asynchronous reset into state B
        end else begin
            case (state)
                1'b0: begin // State A
                    if (in == 1'b0)
                        state <= 1'b1; // A --0--> B
                    else
                        state <= 1'b0; // A --1--> A
                end
                1'b1: begin // State B
                    if (in == 1'b0)
                        state <= 1'b0; // B --0--> A
                    else
                        state <= 1'b1; // B --1--> B
                end
                default: state <= 1'b1;
            endcase
        end
    end

    // Moore output: depends only on the current state
    assign out = state;

endmodule
