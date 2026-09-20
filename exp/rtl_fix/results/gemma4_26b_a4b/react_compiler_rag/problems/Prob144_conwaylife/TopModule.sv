module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer r, c;
    reg [255:0] next_q;
    reg [3:0] neighbors;
    integer nr, nc;
    integer row, col;

    always @(*) begin
        next_q = 256'b0;
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                for (nr = -1; nr <= 1; nr = nr + 1) begin
                    for (nc = -1; nc <= 1; nc = nc + 1) begin
                        if (!(nr == 0 && nc == 0)) begin
                            row = (r + nr + 16) % 16;
                            col = (c + nc + 16) % 16;
                            if (q[row * 16 + col]) begin
                                neighbors = neighbors + 1;
                            end
                        end
                    end
                end
                
                if (neighbors == 3) begin
                    next_q[r * 16 + c] = 1'b1;
                end else if (neighbors == 2) begin
                    next_q[r * 16 + c] = q[r * 16 + c];
                end else begin
                    next_q[r * 16 + c] = 1'b0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
