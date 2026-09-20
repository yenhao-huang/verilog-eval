module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    localparam [3:0] A = 4'd0,
                     B = 4'd1,
                     C = 4'd2,
                     D = 4'd3,
                     E = 4'd4,
                     F = 4'd5,
                     G = 4'd6,
                     H = 4'd7,
                     I = 4'd8;

    reg [3:0] state;

    initial state = A;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: state <= B;
                B: state <= C;

                // Monitor x for sequence 1, 0, 1
                C: state <= x ? D : C;
                D: state <= x ? D : E;
                E: state <= x ? F : C;

                // g = 1, wait up to two clock cycles for y = 1
                F: state <= y ? G : H;
                H: state <= y ? G : I;

                // Permanent outcomes
                G: state <= G;
                I: state <= I;

                default: state <= A;
            endcase
        end
    end

    assign f = (state == B);
    assign g = (state == F) || (state == G) || (state == H);

endmodule
