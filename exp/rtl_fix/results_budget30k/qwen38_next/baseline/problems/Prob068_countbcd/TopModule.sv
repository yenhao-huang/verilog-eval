module TopModule (
    input  wire        clk,
    input  wire        reset,
    output wire [2:0]  ena,
    output wire [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // q[3:0]   = ones
    // q[7:4]   = tens
    // q[11:8]  = hundreds
    // q[15:12] = thousands
    assign q = {thousands, hundreds, tens, ones};

    // ena[0] enables tens digit
    // ena[1] enables hundreds digit
    // ena[2] enables thousands digit
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) && ena[0];
    assign ena[2] = (hundreds == 4'd9) && ena[1];

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;

            if (ena[0])
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;

            if (ena[1])
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;

            if (ena[2])
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

endmodule
