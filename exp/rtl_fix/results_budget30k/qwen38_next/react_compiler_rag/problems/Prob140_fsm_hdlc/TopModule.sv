module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    localparam [3:0] S0 = 4'd0, // previous input was 0, no ones counted
                     S1 = 4'd1, // 1 one
                     S2 = 4'd2, // 2 ones
                     S3 = 4'd3, // 3 ones
                     S4 = 4'd4, // 4 ones
                     S5 = 4'd5, // 5 ones
                     S6 = 4'd6, // 6 ones
                     SD = 4'd7, // discard output state (0111110)
                     SF = 4'd8, // flag output state (01111110)
                     SE = 4'd9; // error output state (7 or more ones)

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0:  state <= in ? S1 : S0;
                S1:  state <= in ? S2 : S0;
                S2:  state <= in ? S3 : S0;
                S3:  state <= in ? S4 : S0;
                S4:  state <= in ? S5 : S0;
                S5:  state <= in ? S6 : SD;   // 0111110 -> discard
                S6:  state <= in ? SE : SF;   // 01111110 -> flag, 7+ ones -> error
                SD:  state <= in ? S1 : S0;
                SF:  state <= in ? S1 : S0;
                SE:  state <= in ? SE : S0;
                default: state <= S0;
            endcase
        end
    end

    // Moore outputs: asserted for one full cycle after the condition occurs
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule
