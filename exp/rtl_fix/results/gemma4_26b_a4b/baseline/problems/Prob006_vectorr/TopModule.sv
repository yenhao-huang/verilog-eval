module TopModule (
    input  [7:0] in,
    output reg [7:0] out
);

    // Integer used for the loop index
    integer i;

    // Combinational logic to reverse the bits
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Assign the bit at index 'i' of the output 
            // to the bit at the mirrored index of the input
            out[i] = in[7 - i];
        end
    end

endmodule
