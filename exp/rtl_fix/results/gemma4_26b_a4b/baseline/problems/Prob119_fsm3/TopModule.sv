module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    // Sequential logic: State Register
    // Implements a positive edge triggered asynchronous reset to state A
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic: Next State Logic
    // Based on the provided state transition table
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in == 1'b1)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                if (in == 1'b1)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                if (in == 1'b1)
                    next_state = B;
                else
                    next_state = C;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    // Combinational logic: Output Logic
    // Moore machine: output depends only on the current state
    // State A: 0, B: 0, C: 0, D: 1
    assign out = (current_state == D);

endmodule
