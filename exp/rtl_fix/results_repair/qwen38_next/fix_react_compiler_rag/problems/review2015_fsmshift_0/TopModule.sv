module top_module(
    input clk,
    input reset,
    output shift_ena);

    // State encoding: B0 = 3'b000, B1 = 3'b001, B2 = 3'b010, B3 = 3'b011, Done = 3'b100
    localparam B0 = 3'b000,
               B1 = 3'b001,
               B2 = 3'b010,
               B3 = 3'b011,
               DONE = 3'b100;

    reg [2:0] state, next_state;

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            B0:    next_state = B1;
            B1:    next_state = B2;
            B2:    next_state = B3;
            B3:    next_state = DONE;
            DONE:  next_state = DONE;
            default: next_state = DONE;
        endcase
    end

    // State register with active-high SYNCHRONOUS reset
    always @(posedge clk) begin
        if (reset)
            state <= B0;
        else
            state <= next_state;
    end

    // Enable the shift register during the 4 shift cycles (B0..B3)
    assign shift_ena = (state == B0) || (state == B1) || (state == B2) || (state == B3);

endmodule
