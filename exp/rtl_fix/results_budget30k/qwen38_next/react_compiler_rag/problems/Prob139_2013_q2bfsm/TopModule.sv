module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    localparam [3:0] A = 4'd0; // reset / beginning state
    localparam [3:0] B = 4'd1; // f = 1 for one clock cycle
    localparam [3:0] C = 4'd2; // waiting for x = 1
    localparam [3:0] D = 4'd3; // waiting for x = 0
    localparam [3:0] E = 4'd4; // waiting for x = 1 (third in sequence)
    localparam [3:0] F = 4'd5; // g = 1, check y (1st cycle)
    localparam [3:0] G = 4'd6; // g = 1, check y (2nd cycle)
    localparam [3:0] H = 4'd7; // g = 1 permanently
    localparam [3:0] I = 4'd8; // g = 0 permanently

    reg [3:0] state;

    initial state = A;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A:      state <= B;                       // reset released -> assert f
                B:      state <= C;                       // f only high one cycle
                C:      state <= x ? D : C;               // need 1
                D:      state <= x ? D : E;               // need 0 (a 1 restarts sequence)
                E:      state <= x ? F : C;               // need 1 -> g = 1
                F:      state <= y ? H : G;               // y seen in 1st cycle?
                G:      state <= y ? H : I;               // y seen in 2nd cycle?
                H:      state <= H;                       // g stays 1
                I:      state <= I;                       // g stays 0
                default: state <= A;
            endcase
        end
    end

    assign f = (state == B);
    assign g = (state == F) || (state == G) || (state == H);

endmodule
