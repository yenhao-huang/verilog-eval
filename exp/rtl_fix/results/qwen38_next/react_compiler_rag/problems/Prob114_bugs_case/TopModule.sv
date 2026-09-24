module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    reg [3:0] out_r;
    reg       valid_r;

    always @(*) begin
        out_r   = 4'd0;
        valid_r = 1'b0;

        case (code)
            8'h45: begin out_r = 4'd0; valid_r = 1'b1; end
            8'h16: begin out_r = 4'd1; valid_r = 1'b1; end
            8'h1e: begin out_r = 4'd2; valid_r = 1'b1; end
            8'h26: begin out_r = 4'd3; valid_r = 1'b1; end
            8'h25: begin out_r = 4'd4; valid_r = 1'b1; end
            8'h2e: begin out_r = 4'd5; valid_r = 1'b1; end
            8'h36: begin out_r = 4'd6; valid_r = 1'b1; end
            8'h3d: begin out_r = 4'd7; valid_r = 1'b1; end
            8'h3e: begin out_r = 4'd8; valid_r = 1'b1; end
            8'h46: begin out_r = 4'd9; valid_r = 1'b1; end
            default: begin out_r = 4'd0; valid_r = 1'b0; end
        endcase
    end

    assign out   = out_r;
    assign valid = valid_r;

endmodule
