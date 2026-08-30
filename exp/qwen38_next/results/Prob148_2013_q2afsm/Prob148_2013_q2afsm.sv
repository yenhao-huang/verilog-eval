module TopModule (
    input  logic       clk,
    input  logic       resetn,
    input  logic [2:0] r,
    output logic [2:0] g
);

    localparam logic [1:0] A = 2'b00;
    localparam logic [1:0] B = 2'b01;
    localparam logic [1:0] C = 2'b10;
    localparam logic [1:0] D = 2'b11;

    logic [1:0] state = A;
    logic [1:0] next_state;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            A: begin
                if (r[0]) begin
                    next_state = B;
                end else if (r[1]) begin
                    next_state = C;
                end else if (r[2]) begin
                    next_state = D;
                end else begin
                    next_state = A;
                end
            end

            B: begin
                if (r[0]) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end

            C: begin
                if (r[1]) begin
                    next_state = C;
                end else begin
                    next_state = A;
                end
            end

            D: begin
                if (r[2]) begin
                    next_state = D;
                end else begin
                    next_state = A;
                end
            end

            default: begin
                next_state = A;
            end
        endcase
    end

    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule
