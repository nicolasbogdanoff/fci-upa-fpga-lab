// One-cycle fixed-point relaxation kernel.
// state_next = state_in + alpha * (target - state_in)
// state and target: signed Q8.8, alpha: unsigned Q0.8.
import fixed_point_pkg::*;

module thermal_kernel (
    input  logic               clk,
    input  logic               reset_n,
    input  logic               start,
    input  logic signed [15:0] state_in_q8_8,
    input  logic signed [15:0] target_q8_8,
    input  logic        [7:0]  alpha_q0_8,
    output logic               busy,
    output logic               done,
    output logic signed [15:0] state_out_q8_8
);

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            busy           <= 1'b0;
            done           <= 1'b0;
            state_out_q8_8 <= '0;
        end else begin
            done <= 1'b0;

            if (busy) begin
                busy <= 1'b0;
                done <= 1'b1;
            end else if (start) begin
                busy           <= 1'b1;
                state_out_q8_8 <= relax_q8_8(state_in_q8_8, target_q8_8, alpha_q0_8);
            end
        end
    end

endmodule
