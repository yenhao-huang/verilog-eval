module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    localparam [3:0] A              = 4'd0,  // reset / idle state
                     F_PULSE        = 4'd1,  // f = 1 for one cycle
                     X_WAIT_1       = 4'd2,  // waiting for first x = 1
                     X_WAIT_0       = 4'd3,  // got x = 1, waiting for x = 0
                     X_WAIT_1_AGAIN = 4'd4,  // got x = 1,0, waiting for x = 1
                     Y_WAIT_0       = 4'd5,  // g = 1, first y check cycle
                     Y_WAIT_1       = 4'd6,  // g = 1, second y check cycle
                     G_PERM         = 4'd7,  // g = 1 permanently
                     G_FAIL         = 4'd8;  // g = 0 permanently

    reg [3:0] state = A;

    // Synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    state <= F_PULSE;
                end

                F_PULSE: begin
                    state <= X_WAIT_1;
                end

                X_WAIT_1: begin
                    if (x)
                        state <= X_WAIT_0;
                    else
                        state <= X_WAIT_1;
                end

                X_WAIT_0: begin
                    // If x = 1 here, keep it as the first 1 of a new sequence.
                    if (x)
                        state <= X_WAIT_0;
                    else
                        state <= X_WAIT_1_AGAIN;
                end

                X_WAIT_1_AGAIN: begin
                    if (x)
                        state <= Y_WAIT_0;
                    else
                        state <= X_WAIT_1;
                end

                Y_WAIT_0: begin
                    if (y)
                        state <= G_PERM;
                    else
                        state <= Y_WAIT_1;
                end

                Y_WAIT_1: begin
                    if (y)
                        state <= G_PERM;
                    else
                        state <= G_FAIL;
                end

                G_PERM: begin
                    state <= G_PERM;
                end

                G_FAIL: begin
                    state <= G_FAIL;
                end

                default: begin
                    state <= A;
                end
            endcase
        end
    end

    // Output decoding
    assign f = (state == F_PULSE);
    assign g = (state == Y_WAIT_0 || state == Y_WAIT_1 || state == G_PERM);

endmodule
