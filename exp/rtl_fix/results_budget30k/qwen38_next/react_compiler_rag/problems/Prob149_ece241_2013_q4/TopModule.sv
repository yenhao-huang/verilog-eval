module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    localparam LOW   = 2'd0;  // below s[0]        : s = 3'b000
    localparam MID1  = 2'd1;  // between s[0],s[1] : s = 3'b001
    localparam MID2  = 2'd2;  // between s[1],s[2] : s = 3'b011
    localparam HIGH  = 2'd3;  // above s[2]        : s = 3'b111

    reg [1:0] current;   // current water level
    reg [1:0] previous;  // level before the last sensor change

    // decode sensors into a water level
    wire [1:0] next_level = s[2] ? HIGH  :
                            s[1] ? MID2  :
                            s[0] ? MID1  : LOW;

    always @(posedge clk) begin
        if (reset) begin
            current  <= LOW;
            previous <= LOW;
        end else begin
            if (next_level != current) begin
                previous <= current;   // remember level before this change
                current  <= next_level;
            end
        end
    end

    // nominal flow rate valves from the current level
    assign fr0 = (current != HIGH);
    assign fr1 = (current == LOW || current == MID1);
    assign fr2 = (current == LOW);

    // supplemental valve: max flow when lowest, or when level rose
    assign dfr = (current == LOW) ||
                 ((current == MID1 || current == MID2) && (previous < current));
endmodule
