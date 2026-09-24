module TopModule (
    input  wire      clk,
    input  wire      reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Galois LFSR shift right with taps at bit positions 5 and 3
            // Tap 5 -> q[4], tap 3 -> q[2]
            q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
        end
    end

endmodule
