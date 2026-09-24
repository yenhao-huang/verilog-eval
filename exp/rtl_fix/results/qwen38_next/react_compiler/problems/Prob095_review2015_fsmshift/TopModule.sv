module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

    // States 0..3 => the four shift-enable cycles
    // State 4 (DONE) => shift_ena deasserted forever (until next reset)
    localparam DONE = 3'd4;

    reg [2:0] state;

    initial state = DONE;   // not shifting before the first reset

    always @(posedge clk) begin
        if (reset)                    // synchronous, active-high reset
            state <= 3'd0;
        else if (state != DONE)
            state <= state + 3'd1;
    end

    assign shift_ena = (state != DONE);

endmodule
