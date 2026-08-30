module TopModule (
    input  logic clk,
    input  logic aresetn,
    input  logic x,
    output logic z
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        GOT1  = 2'b01,
        GOT10 = 2'b10
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                next_state = x ? GOT1 : IDLE;
            end
            GOT1: begin
                next_state = x ? GOT1 : GOT10;
            end
            GOT10: begin
                next_state = x ? GOT1 : IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign z = (state == GOT10) && x;

endmodule
