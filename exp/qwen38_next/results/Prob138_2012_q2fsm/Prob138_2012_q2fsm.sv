module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic w,
    output logic z
);

    localparam logic [2:0] A = 3'd0;
    localparam logic [2:0] B = 3'd1;
    localparam logic [2:0] C = 3'd2;
    localparam logic [2:0] D = 3'd3;
    localparam logic [2:0] E = 3'd4;
    localparam logic [2:0] F = 3'd5;

    logic [2:0] state;
    logic [2:0] next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    assign z = (state == E) || (state == F);

endmodule
