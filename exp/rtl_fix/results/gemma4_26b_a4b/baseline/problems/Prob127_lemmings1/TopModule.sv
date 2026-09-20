module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    // We use a single bit to represent the two states:
    // 0: Walking Left
    // 1: Walking Right
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;

    // Sequential logic for the Finite State Machine (FSM)
    // The FSM is triggered on the positive edge of the clock.
    // areset is an asynchronous positive-edge triggered reset.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset the Lemming to walk left
            state <= WALK_LEFT;
        end else begin
            // Transition logic based on the provided rules:
            // 1. If bumped on both sides, switch direction (toggle state).
            // 2. If bumped on the left, walk right.
            // 3. If bumped on the right, walk left.
            
            if (bump_left && bump_right) begin
                state <= ~state;
            end else if (bump_left) begin
                state <= WALK_RIGHT;
            end else if (bump_right) begin
                state <= WALK_LEFT;
            end
            // If no bumps occur, the state remains unchanged (implicit).
        end
    end

    // Moore machine output logic:
    // In a Moore machine, the outputs depend only on the current state.
    // walk_left is 1 when the state is WALK_LEFT, otherwise 0.
    // walk_right is 1 when the state is WALK_RIGHT, otherwise 0.
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule
