module TopModule (
    input             clk,
    input             load,
    input  [255:0]    data,
    output [255:0]    q
);

    reg [255:0] q;
    reg [255:0] next_q;

    integer r, c, n;

    // Count the 8 neighbours of cell (r,c) on a 16x16 torus
    function integer count_neighbors;
        input [255:0] state;
        input integer r;
        input integer c;
        integer i, j, cnt;
        begin
            cnt = 0;
            for (i = -1; i <= 1; i = i + 1) begin
                for (j = -1; j <= 1; j = j + 1) begin
                    if (i != 0 || j != 0) begin
                        cnt = cnt + state[(((r + i + 16) % 16) * 16) + ((c + j + 16) % 16)];
                    end
                end
            end
            count_neighbors = cnt;
        end
    endfunction

    // Next state: live with 2 or 3 neighbours, or dead with exactly 3 neighbours
    always @* begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                n = count_neighbors(q, r, c);
                next_q[r*16 + c] = (n == 3) || (q[r*16 + c] && (n == 2));
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
