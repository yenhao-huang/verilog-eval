module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    // A priority encoder is a combinational circuit.
    // We use always @(*) to ensure the logic is combinational.
    // The problem specifies that if no bits are high, the output should be zero.
    // We also need to find the position of the first (lowest index) 1 bit.
    
    always @(*) begin
        if (in[0]) begin
            pos = 2'd0;
        end else if (in[1]) begin
            pos = 2'd1;
        end else if (in[2]) begin
            pos = 2'd2;
        end else if (in[3]) begin
            pos = 2'd3;
        end else begin
            // If no bits are high (in == 0), output zero.
            pos = 2'd0;
        end
    end

endmodule
