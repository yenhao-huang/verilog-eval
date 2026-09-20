module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    localparam [1:0] IDLE  = 2'd0;  // no useful prefix seen
    localparam [1:0] GOT1  = 2'd1;  // saw "1"
    localparam [1:0] GOT10 = 2'd2;  // saw "10"

    reg [1:0] state;

    // State register: positive clock edge, async active-low reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= x ? GOT1  : IDLE;
                GOT1:  state <= x ? GOT1  : GOT10;
                GOT10: state <= x ? GOT1  : IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Mealy output: assert z when in "10" state and current input is 1
    assign z = (state == GOT10) && x;

endmodule
