module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    localparam [2:0] S0 = 3'd0,
                     S1 = 3'd1,
                     S2 = 3'd2,
                     S3 = 3'd3,
                     S4 = 3'd4;

    reg [2:0] state;

    initial begin
        state = S4;
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0:      state <= S1;
                S1:      state <= S2;
                S2:      state <= S3;
                S3:      state <= S4;
                S4:      state <= S4;
                default: state <= S4;
            endcase
        end
    end

    assign shift_ena = (state == S0) ||
                       (state == S1) ||
                       (state == S2) ||
                       (state == S3);

endmodule
