module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output wire z
);

    localparam [1:0] IDLE  = 2'd0,  // no useful prefix seen
                     GOT1  = 2'd1,  // saw '1'
                     GOT10 = 2'd2;  // saw '10'

    reg [1:0] state;

    // State register with negative-edge asynchronous active-low reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (x) state <= GOT1;
                    else   state <= IDLE;
                end

                GOT1: begin
                    if (x) state <= GOT1;   // keep the most recent '1' as prefix
                    else   state <= GOT10;  // now have "10"
                end

                GOT10: begin
                    if (x) state <= GOT1;   // "101" detected; this '1' starts next match
                    else   state <= IDLE;   // "100" -> no valid prefix
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Mealy output: asserted when "10" already seen and current x = 1
    assign z = (state == GOT10) && x;

endmodule
