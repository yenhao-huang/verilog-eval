module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

    // The module implements a 9-to-1 multiplexer using a combinational always block.
    // The 'reg' type for 'out' is required because it is assigned within an always block.
    always @(*) begin
        case (sel)
            4'd0: out = a;
            4'd1: out = b;
            4'd2: out = c;
            4'd3: out = d;
            4'd4: out = e;
            4'd5: out = f;
            4'd6: out = g;
            4'd7: out = h;
            4'd8: out = i;
            // For sel values 9 through 15, the default case handles setting the output to all '1's.
            default: out = 16'hFFFF;
        endcase
    end

endmodule
