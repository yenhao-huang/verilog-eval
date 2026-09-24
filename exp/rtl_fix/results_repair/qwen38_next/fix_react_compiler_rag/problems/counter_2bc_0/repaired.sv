module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b01;              // asynchronous reset to weakly not-taken
    end else if (train_valid) begin
      if (train_taken && (state < 2'b11)) begin
        state <= state + 2'b01;    // saturating up-count, max = 3
      end else if (!train_taken && (state > 2'b00)) begin
        state <= state - 2'b01;    // saturating down-count, min = 0
      end
    end
    // train_valid == 0: state holds its value
  end

endmodule
