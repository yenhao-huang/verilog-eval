module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    parameter OFF = 1'b0;
    parameter ON = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: if (j) state <= ON; else state <= OFF;
                ON:  if (k) state <= OFF; else state <= ON;
                default: state <= OFF;
            endcase
        end
    end

    assign out = (state == ON);

endmodule
