module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // The module implements 16 D flip-flops controlled by a clock and a synchronous reset.
    // Byte-enable signals allow for partial updates of the 16-bit register.
    always @(posedge clk) begin
        if (!resetn) begin
            // Synchronous, active-low reset: clear all 16 bits
            q <= 16'h0000;
        end else begin
            // byteena[0] controls the lower byte (bits 7:0)
            if (byteena[0]) begin
                q[7:0] <= d[7:0];
            end
            
            // byteena[1] controls the upper byte (bits 15:8)
            if (byteena[1]) begin
                q[15:8] <= d[15:8];
            end
        end
    end

endmodule
