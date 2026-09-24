module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    // Behaviour derived from the waveform:
    //  - When a = 1, q is loaded/held at 4 (3'b100).
    //  - When a = 0, q increments on each clock edge, wrapping from 6 back to 0
    //    (sequence seen: 4 -> 5 -> 6 -> 0 -> 1 ...).
    always @(posedge clk) begin
        if (a)
            q <= 3'd4;
        else if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end

endmodule
