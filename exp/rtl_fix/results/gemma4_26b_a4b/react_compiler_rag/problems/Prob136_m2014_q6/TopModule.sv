module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    parameter A = 3'b000,
              B = 3'b001,
              C = 3'b010,
              D = 3'b011,
              E = 3'b100,
              F = 3'b101;

    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: if (w == 0) state <= B; else state <= A;
                B: if (w == 0) state <= C; else state <= D;
                C: if (w == 0) state <= E; else state <= D;
                D: if (w == 0) state <= F; else state <= A;
                E: if (w == 0) state <= E; else state <= D;
                F: if (w == 0) state <= C; else state <= D;
                default: state <= A;
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: z = 0;
            B: z = 0;
            C: z = 0;
            D: z = 0;
            E: z = 1;
            F: z = 1;
            default: z = 0;
        endcase
    end

endmodule
