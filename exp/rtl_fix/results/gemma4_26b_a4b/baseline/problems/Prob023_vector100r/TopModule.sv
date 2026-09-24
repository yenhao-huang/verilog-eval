module TopModule (
    input  [99:0] in,
    output reg [99:0] out
);

    // Integer used for the loop index
    integer i;

    // Combinational logic to reverse the bit ordering
    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            out[i] = in[99 - i];
        end
    end

endmodule
