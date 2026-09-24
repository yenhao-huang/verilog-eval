module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Water levels (encoded so that ordering matches physical height)
    localparam [1:0] LOW  = 2'd0;  // s = 000 : below s[0]
    localparam [1:0] MID1 = 2'd1;  // s = 001 : between s[0] and s[1]
    localparam [1:0] MID2 = 2'd2;  // s = 011 : between s[1] and s[2]
    localparam [1:0] HIGH = 2'd3;  // s = 111 : above s[2]

    reg [3:0] state;      // {current level, level previous to last sensor change}
    reg [3:0] next_state;
    reg [1:0] s_level;

    wire [1:0] cur  = state[3:2];  // current water level
    wire [1:0] prev = state[1:0];  // level previous to the last sensor change

    // State register: synchronous, active-high reset to "low for a long time"
    always @(posedge clk) begin
        if (reset)
            state <= {LOW, LOW};
        else
            state <= next_state;
    end

    // Decode the sensor inputs into a level (hold level for invalid codes)
    always @(*) begin
        case (s)
            3'b000:  s_level = LOW;
            3'b001:  s_level = MID1;
            3'b011:  s_level = MID2;
            3'b111:  s_level = HIGH;
            default: s_level = cur;
        endcase
    end

    // Next state: if the level changed, the old current level becomes "prev"
    always @(*) begin
        if (s_level == cur)
            next_state = {cur, prev};   // no change: remember old prev
        else
            next_state = {s_level, cur}; // change: prev = previous level
    end

    // Nominal flow rates from the table
    assign fr2 = (cur == LOW);
    assign fr1 = (cur == LOW) || (cur == MID1);
    assign fr0 = (cur == LOW) || (cur == MID1) || (cur == MID2);

    // Supplemental valve: open if previous level was lower than current level
    // (already at maximum when below s[0]; zero flow when above s[2])
    assign dfr = (cur == LOW) ||
                 (cur == MID1 && prev == LOW) ||
                 (cur == MID2 && (prev == LOW || prev == MID1));

endmodule
