module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [1:0] last_state;
    reg dfr_reg;
    reg [1:0] current_state;

    // Determine current state based on sensors
    always @(*) begin
        if (s[2] && s[1] && s[0])
            current_state = 2'd3; // Above s[2]
        else if (s[1] && s[0])
            current_state = 2'd2; // Between s[2] and s[1]
        else if (s[0])
            current_state = 2'd1; // Between s[1] and s[0]
        else
            current_state = 2'd0; // Below s[0]
    end

    // Update last_state and dfr_reg on clock edge
    always @(posedge clk) begin
        if (reset) begin
            // Reset state to "below s[0]" and all outputs asserted
            last_state <= 2'd0;
            dfr_reg <= 1'b1;
        end else begin
            if (current_state != last_state) begin
                // If current level is higher than last level, increase flow
                if (current_state > last_state)
                    dfr_reg <= 1'b1;
                else
                    dfr_reg <= 1'b0;
                last_state <= current_state;
            end
        end
    end

    // Output logic
    always @(*) begin
        case (current_state)
            2'd3: begin // Above s[2]
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end
            2'd2: begin // Between s[2] and s[1]
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = dfr_reg;
            end
            2'd1: begin // Between s[1] and s[0]
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = dfr_reg;
            end
            2'd0: begin // Below s[0]
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end
            default: begin
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end
        endcase
    end

endmodule
