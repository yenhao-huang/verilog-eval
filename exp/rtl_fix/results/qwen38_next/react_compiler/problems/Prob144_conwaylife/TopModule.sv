module TopModule (
    input            clk,
    input            load,
    input  [255:0]   data,
    output [255:0]   q
);

    reg [255:0] q;
    integer i, dr, dc, r, c, n;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 256; i = i + 1) begin
                // Count the 8 neighbours on a 16x16 torus
                n = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            r = ((i / 16) + dr + 16) % 16;   // row, wrapped
                            c = ((i % 16) + dc + 16) % 16;   // col, wrapped
                            n = n + q[r * 16 + c];
                        end
                    end
                end
                // Rules: 3 neighbours -> alive; 2 neighbours -> unchanged; else dead
                q[i] <= (n == 3) || (n == 2 && q[i]);
            end
        end
    end

endmodule
