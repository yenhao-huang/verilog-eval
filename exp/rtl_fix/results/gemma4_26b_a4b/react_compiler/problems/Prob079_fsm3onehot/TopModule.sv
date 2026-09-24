module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

always @(*) begin
    next_state = 4'b0000;
    out = 1'b0;
    
    if (state[0]) begin // State A
        if (in == 1'b0)
            next_state = 4'b0001; // A
        else
            next_state = 4'b0010; // B
    end else if (state[1]) begin // State B
        if (in == 1'b0)
            next_state = 4'b0100; // C
        else
            next_state = 4'b0010; // B
    end else if (state[2]) begin // State C
        if (in == 1'b0)
            next_state = 4'b0001; // A
        else
            next_state = 4'b1000; // D
    end else if (state[3]) begin // State D
        if (in == 1'b0)
            next_state = 4'b0100; // C
        else
            next_state = 4'b0010; // B
        out = 1'b1;
    end
end

endmodule
