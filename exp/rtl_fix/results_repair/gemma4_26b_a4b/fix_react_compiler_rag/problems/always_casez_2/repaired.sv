module top_module (
	input [7:0] in,
	output reg [2:0] pos
);

always @(*) begin
    pos = 3'b0;
    for (integer i = 7; i >= 0; i = i - 1) begin
        if (in[i]) begin
            pos = i[2:0];
        end
    end
end

endmodule
