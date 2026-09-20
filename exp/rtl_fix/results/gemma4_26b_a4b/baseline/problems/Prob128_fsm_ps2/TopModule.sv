module TopModule (
    input            clk,
    input            reset,
    input      [7:0] in,
    output           done
);

    // State encoding for the Finite State Machine
    // SEARCH: Looking for the start of a message (in[3] == 1)
    // B2:     The first byte has been received; waiting for the second byte
    // B3:     The second byte has been received; waiting for the third byte
    // DONE:   The third byte has been received; signaling completion
    localparam SEARCH = 2'b00;
    localparam B2     = 2'b01;
    localparam B3     = 2'b10;
    localparam DONE   = 2'b11;

    reg [1:0] state;

    // Sequential logic for state transitions
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset
            state <= SEARCH;
        end else begin
            case (state)
                SEARCH: begin
                    // Discard bytes until in[3] is 1
                    if (in[3]) begin
                        state <= B2;
                    end else begin
                        state <= SEARCH;
                    end
                end

                B2: begin
                    // Byte 1 was received, now move to collect Byte 2
                    state <= B3;
                end

                B3: begin
                    // Byte 2 was received, now move to collect Byte 3
                    state <= DONE;
                end

                DONE: begin
                    // We are in the cycle immediately after the 3rd byte was received.
                    // We check the current byte (the one arriving during the DONE cycle)
                    // to see if it is the start of a new message.
                    if (in[3]) begin
                        state <= B2;
                    end else begin
                        state <= SEARCH;
                    end
                end

                default: begin
                    state <= SEARCH;
                end
            endcase
        end
    end

    // The done signal is high during the DONE state, 
    // which occurs exactly one cycle after the 3rd byte is received.
    assign done = (state == DONE);

endmodule
