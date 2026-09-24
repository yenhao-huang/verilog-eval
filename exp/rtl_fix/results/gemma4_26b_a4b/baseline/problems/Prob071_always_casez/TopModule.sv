module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

    /*
     * The module implements a priority encoder for an 8-bit input.
     * It identifies the least significant bit (LSB) that is set to 1.
     * 
     * Priority Logic:
     * - If in[0] is 1, pos = 0
     * - If in[1] is 1 (and in[0] is 0), pos = 1
     * - ...
     * - If in[7] is 1 (and in[0:6] are 0), pos = 7
     * - If no bits are 1, pos = 0 (as per requirement)
     */

    always @(*) begin
        if (in[0]) begin
            pos = 3'd0;
        end else if (in[1]) begin
            pos = 3'd1;
        end else if (in[2]) begin
            pos = 3'd2;
        end else if (in[3]) begin
            pos = 3'd3;
        end else if (in[4]) begin
            pos = 3'd4;
        end else if (in[5]) begin
            pos = 3'd5;
        end else if (in[6]) begin
            pos = 3'd6;
        end else if (in[7]) begin
            pos = 3'd7;
        end else begin
            // If no bits are high, report zero.
            pos = 3'd0;
        end
    end

endmodule
