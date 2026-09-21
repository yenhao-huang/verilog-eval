module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // state encoding: 1'b0 = OFF (out=0), 1'b1 = ON (out=1)
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;                 // synchronous reset to OFF
        else if (state == 1'b0)
            state <= j;                    // OFF: j=1 -> ON, j=0 -> OFF
        else
            state <= ~k;                   // ON:  k=1 -> OFF, k=0 -> ON
    end

    assign out = state;                    // Moore output

endmodule
