module TopModule (
    input             clk,
    input             reset,
    input      [31:0] in,
    output     [31:0] out
);

    reg [31:0] in_d;    // previous value of in
    reg [31:0] out_r;   // sticky captured output

    always @(posedge clk) begin
        in_d <= in;                 // remember previous cycle's input
        if (reset)
            out_r <= 32'h0;         // synchronous, active-high reset
        else
            out_r <= out_r | (~in & in_d);   // capture 1 -> 0 transitions
    end

    assign out = out_r;

endmodule
