module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    localparam [1:0] A = 2'b00;
    localparam [1:0] B = 2'b01;
    localparam [1:0] C = 2'b10;
    localparam [1:0] D = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // State flip-flops with active-low synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic (state table)
    always @(*) begin
        case (state)
            A: begin
                if (r[0])
                    next_state = B;          // device 0 has highest priority
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;          // no requests
            end

            B: next_state = r[0] ? B : A;    // grant held while r[0] = 1
            C: next_state = r[1] ? C : A;    // grant held while r[1] = 1
            D: next_state = r[2] ? D : A;    // grant held while r[2] = 1

            default: next_state = A;
        endcase
    end

    // Moore outputs: g is asserted only in the corresponding grant state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule
