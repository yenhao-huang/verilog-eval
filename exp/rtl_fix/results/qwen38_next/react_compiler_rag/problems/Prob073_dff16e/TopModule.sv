module TopModule (
    input             clk,
    input             resetn,
    input      [1:0]  byteena,
    input      [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'h0000;          // synchronous active-low reset
        end else begin
            if (byteena[1])
                q[15:8] <= d[15:8]; // upper byte enable
            if (byteena[0])
                q[7:0]  <= d[7:0];  // lower byte enable
        end
    end

endmodule
