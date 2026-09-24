module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    localparam [1:0] A = 2'b00;
    localparam [1:0] B = 2'b01;
    localparam [1:0] C = 2'b10;
    localparam [1:0] D = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            case (state)
                A: begin
                    if (in)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    if (in)
                        state <= B;
                    else
                        state <= C;
                end

                C: begin
                    if (in)
                        state <= D;
                    else
                        state <= A;
                end

                D: begin
                    if (in)
                        state <= B;
                    else
                        state <= C;
                end

                default: begin
                    state <= A;
                end
            endcase
        end
    end

    assign out = (state == D);

endmodule
