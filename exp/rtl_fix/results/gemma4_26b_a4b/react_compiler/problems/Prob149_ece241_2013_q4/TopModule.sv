module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [1:0] current_level;
    reg [1:0] prev_level;

    always @(*) begin
        if (s[2] && s[1] && s[0])
            current_level = 2'd3;
        else if (s[1] && s[0])
            current_level = 2'd2;
        else if (s[0])
            current_level = 2'd1;
        else
            current_level = 2'd0;
    end

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_level <= current_level;
            case (current_level)
                2'd3: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                2'd2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= (current_level > prev_level) ? 1'b1 : 1'b0;
                end
                2'd1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= (current_level > prev_level) ? 1'b1 : 1'b0;
                end
                2'd0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
                default: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            endcase
        end
    end

endmodule
