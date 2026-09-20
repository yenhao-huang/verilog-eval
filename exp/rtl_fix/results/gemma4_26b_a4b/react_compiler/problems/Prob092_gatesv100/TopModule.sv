module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    integer i;

    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            // out_both: in[i] and its neighbour to the left (in[i+1])
            if (i < 99)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0;

            // out_any: in[i] or its neighbour to the right (in[i-1])
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0;

            // out_different: in[i] different from its neighbour to the left (in[i+1] with wrap-around)
            out_different[i] = in[i] ^ in[(i+1)%100];
        end
    end

endmodule
