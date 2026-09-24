module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);

    // Integer used for the loop index
    integer i;

    // Combinational logic to perform population count
    // We use an always @(*) block to ensure the output updates 
    // whenever the input changes.
    always @(*) begin
        // Initialize the output to 0 at the start of every evaluation
        out = 8'd0;
        
        // Iterate through every bit of the 255-bit input vector
        for (i = 0; i < 255; i = i + 1) begin
            if (in[i]) begin
                out = out + 1'b1;
            end
        end
    end

endmodule
