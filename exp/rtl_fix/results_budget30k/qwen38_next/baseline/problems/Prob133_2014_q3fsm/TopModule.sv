module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // A: wait for s = 1
    // B: start of a 3-cycle w check, 0 ones seen so far
    // C: after 1 cycle, 0 ones seen
    // D: after 1 cycle, 1 one seen
    // E: after 2 cycles, 0 ones seen
    // F: after 2 cycles, 1 one seen
    // G: after 2 cycles, 2 ones seen
    localparam [2:0] A = 3'd0,
                     B = 3'd1,
                     C = 3'd2,
                     D = 3'd3,
                     E = 3'd4,
                     F = 3'd5,
                     G = 3'd6;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z     <= 1'b0;
        end else begin
            case (state)
                A: begin
                    state <= s ? B : A;
                    z     <= 1'b0;
                end

                B: begin
                    state <= w ? D : C;
                    z     <= 1'b0;
                end

                C: begin
                    state <= w ? F : E;
                    z     <= 1'b0;
                end

                D: begin
                    state <= w ? G : F;
                    z     <= 1'b0;
                end

                E: begin
                    state <= B;
                    z     <= 1'b0;
                end

                F: begin
                    state <= B;
                    z     <= w;      // need w = 1 to make exactly two 1s
                end

                G: begin
                    state <= B;
                    z     <= ~w;     // need w = 0 to make exactly two 1s
                end

                default: begin
                    state <= A;
                    z     <= 1'b0;
                end
            endcase
        end
    end

endmodule
