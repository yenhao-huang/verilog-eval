module TopModule (
    input d,
    input ena,
    output reg q
);

    // A D latch is level-sensitive. 
    // When 'ena' is high, the output 'q' follows the input 'd'.
    // When 'ena' is low, 'q' retains its previous value.
    // In Verilog, an always block without an 'else' clause for an 'if' 
    // statement infers a latch.
    always @(*) begin
        if (ena) begin
            q <= d;
        end
    end

endmodule
