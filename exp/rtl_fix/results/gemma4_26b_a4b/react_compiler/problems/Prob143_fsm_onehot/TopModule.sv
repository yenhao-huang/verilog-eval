module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // next_state logic
        // S0: 0->S0, 1->S1
        if (state[0]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[1] = 1'b1;
        end
        // S1: 0->S0, 1->S2
        if (state[1]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[2] = 1'b1;
        end
        // S2: 0->S0, 1->S3
        if (state[2]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[3] = 1'b1;
        end
        // S3: 0->S0, 1->S4
        if (state[3]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[4] = 1'b1;
        end
        // S4: 0->S0, 1->S5
        if (state[4]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[5] = 1'b1;
        end
        // S5: 0->S8, 1->S6
        if (state[5]) begin
            if (!in) next_state[8] = 1'b1;
            else next_state[6] = 1'b1;
        end
        // S6: 0->S9, 1->S7
        if (state[6]) begin
            if (!in) next_state[9] = 1'b1;
            else next_state[7] = 1'b1;
        end
        // S7: 0->S0, 1->S7
        if (state[7]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[7] = 1'b1;
        end
        // S8: 0->S0, 1->S1
        if (state[8]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[1] = 1'b1;
        end
        // S9: 0->S0, 1->S1
        if (state[9]) begin
            if (!in) next_state[0] = 1'b1;
            else next_state[1] = 1'b1;
        end

        // output logic
        // S7 (0, 1)
        if (state[7]) out2 = 1'b1;
        // S8 (1, 0)
        if (state[8]) out1 = 1'b1;
        // S9 (1, 1)
        if (state[9]) begin
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule
