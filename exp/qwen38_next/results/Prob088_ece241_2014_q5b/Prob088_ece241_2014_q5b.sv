module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic x,
    output logic z
);

    localparam logic [1:0] A = 2'b01;
    localparam logic [1:0] B = 2'b10;

    logic [1:0] state;
    logic [1:0] next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        z = 1'b0;

        case (state)
            A: begin
                if (x) begin
                    z = 1'b1;
                    next_state = B;
                end else begin
                    z = 1'b0;
                    next_state = A;
                end
            end

            B: begin
                if (x) begin
                    z = 1'b0;
                    next_state = B;
                end else begin
                    z = 1'b1;
                    next_state = B;
                end
            end

            default: begin
                z = 1'b0;
                next_state = A;
            end
        endcase
    end

endmodule
