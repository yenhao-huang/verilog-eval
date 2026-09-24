module top_module (
    input  [2:0]  a,
    output reg [15:0] q
);

    always @(*) begin
        case (a)
            3'd0:    q = 16'h1232;   // 4658
            3'd1:    q = 16'hAEE0;   // 44768
            3'd2:    q = 16'h27D4;   // 10196
            3'd3:    q = 16'h5A0E;   // 23054
            3'd4:    q = 16'h2066;   // 8294
            3'd5:    q = 16'h64CE;   // 25806
            3'd6:    q = 16'hC526;   // 50470
            3'd7:    q = 16'h2F19;   // 12057
            default: q = 16'h0000;
        endcase
    end

endmodule
