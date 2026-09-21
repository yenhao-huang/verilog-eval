module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

    localparam [2:0] A   = 3'd0;
    localparam [2:0] B0  = 3'd1; // first cycle of a 3-cycle group, count = 0
    localparam [2:0] B10 = 3'd2; // second cycle, count = 0
    localparam [2:0] B11 = 3'd3; // second cycle, count = 1
    localparam [2:0] B20 = 3'd4; // third cycle, count = 0
    localparam [2:0] B21 = 3'd5; // third cycle, count = 1
    localparam [2:0] B22 = 3'd6; // third cycle, count = 2

    reg [2:0] state;
    reg       z;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z     <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    state <= s ? B0 : A;
                end

                B0: begin
                    z <= 1'b0;
                    state <= w ? B11 : B10;
                end

                B10: begin
                    z <= 1'b0;
                    state <= w ? B21 : B20;
                end

                B11: begin
                    z <= 1'b0;
                    state <= w ? B22 : B21;
                end

                B20: begin
                    z <= 1'b0;
                    state <= B0;
                end

                B21: begin
                    z <= w;       // exactly two 1s if this w is 1
                    state <= B0;
                end

                B22: begin
                    z <= ~w;      // exactly two 1s if this w is 0
                    state <= B0;
                end

                default: begin
                    state <= A;
                    z     <= 1'b0;
                end
            endcase
        end
    end

endmodule
