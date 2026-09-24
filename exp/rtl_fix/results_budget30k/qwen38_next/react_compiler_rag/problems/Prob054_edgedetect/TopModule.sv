module TopModule (
    input  wire       clk,
    input  wire [7:0] in,
    output reg  [7:0] pedge
);

    reg [7:0] in_d;   // previous value of each input bit

    always @(posedge clk) begin
        in_d  <= in;              // save current value for next cycle
        pedge <= in & ~in_d;      // 0 -> 1 transition detected
    end

endmodule
