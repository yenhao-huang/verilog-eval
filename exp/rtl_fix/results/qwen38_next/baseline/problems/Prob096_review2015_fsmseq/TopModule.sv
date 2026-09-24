module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot state encoding
    localparam [4:0] S_IDLE   = 5'b00001;
    localparam [4:0] S_GOT1   = 5'b00010;
    localparam [4:0] S_GOT11  = 5'b00100;
    localparam [4:0] S_GOT110 = 5'b01000;
    localparam [4:0] S_DONE   = 5'b10000;

    reg [4:0] state = S_IDLE;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE:   state <= data ? S_GOT1   : S_IDLE;
                S_GOT1:   state <= data ? S_GOT11  : S_IDLE;
                S_GOT11:  state <= data ? S_GOT11  : S_GOT110;
                S_GOT110: state <= data ? S_DONE   : S_IDLE;
                S_DONE:   state <= S_DONE;
                default:  state <= S_IDLE;
            endcase
        end
    end

    assign start_shifting = (state == S_DONE);

endmodule
