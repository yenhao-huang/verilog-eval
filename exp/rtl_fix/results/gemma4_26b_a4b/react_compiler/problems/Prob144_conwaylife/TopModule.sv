module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer r, c, dr, dc;
    integer r_idx, c_idx;
    reg [3:0] count;

    always @(*) begin
        next_q = 256'b0;
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                count = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (dr != 0 || dc != 0) begin
                            r_idx = r + dr;
                            if (r_idx < 0) r_idx = 15;
                            else if (r_idx > 15) r_idx = 0;

                            c_idx = c + dc;
                            if (c_idx < 0) c_idx = 15;
                            else if (c_idx > 15) c_idx = 0;

                            if (q[r_idx * 16 + c_idx]) begin
                                count = count + 1;
                            end
                        end
                    end
                end
                if (count == 3 || (count == 2 && q[r * 16 + c])) begin
                    next_q[r * 16 + c] = 1'b1;
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
