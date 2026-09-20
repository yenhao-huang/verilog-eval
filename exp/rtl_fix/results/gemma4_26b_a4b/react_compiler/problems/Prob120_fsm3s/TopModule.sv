module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    // Define states
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    
    reg [1:0] state, next_state;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic (Moore machine: output depends only on the current state)
    assign out = (state == D);

endmodule
