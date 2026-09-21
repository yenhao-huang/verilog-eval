module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire [2:0] s,
    output wire       fr2,
    output wire       fr1,
    output wire       fr0,
    output wire       dfr
);

    // Water-level states
    localparam [1:0] LOW      = 2'd0; // below s[0], s = 000
    localparam [1:0] MID_LOW  = 2'd1; // between s[1] and s[0], s = 001
    localparam [1:0] MID_HIGH = 2'd2; // between s[2] and s[1], s = 011
    localparam [1:0] HIGH     = 2'd3; // above s[2], s = 111

    reg [1:0] state;
    reg [1:0] next_state;
    reg       dfr_reg;

    // Decode sensor inputs into a water-level state.
    // Valid sensor patterns are 000, 001, 011, 111.
    always @(*) begin
        if (!s[0])
            next_state = LOW;
        else if (!s[1])
            next_state = MID_LOW;
        else if (!s[2])
            next_state = MID_HIGH;
        else
            next_state = HIGH;
    end

    // Synchronous state update.
    always @(posedge clk) begin
        if (reset) begin
            // Equivalent to water level low for a long time:
            // no sensors asserted, all four outputs asserted.
            state    <= LOW;
            dfr_reg  <= 1'b1;
        end else begin
            state <= next_state;

            // Update supplemental flow valve.
            // LOW is always maximum flow, HIGH is always zero flow.
            // For intermediate levels, dfr is set if the level rose.
            if (next_state == LOW) begin
                dfr_reg <= 1'b1;
            end else if (next_state == HIGH) begin
                dfr_reg <= 1'b0;
            end else if (next_state > state) begin
                dfr_reg <= 1'b1;
            end else if (next_state < state) begin
                dfr_reg <= 1'b0;
            end else begin
                dfr_reg <= dfr_reg;
            end
        end
    end

    // Nominal flow-rate outputs based on current water level.
    assign fr2 = (state == LOW);
    assign fr1 = (state == LOW) || (state == MID_LOW);
    assign fr0 = (state == LOW) || (state == MID_LOW) || (state == MID_HIGH);

    // Supplemental flow valve.
    assign dfr = dfr_reg;

endmodule
