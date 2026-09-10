// One-sample-per-cycle streaming version of the fixed-point thermal kernel.
// Inputs are accepted when valid_in is high and appear one cycle later.
// state and target: signed Q8.8, alpha: unsigned Q0.8.
import fixed_point_pkg::*;

module thermal_kernel_stream (
    input  logic               clk,
    input  logic               reset_n,
    input  logic               valid_in,
    input  logic signed [15:0] state_in_q8_8,
    input  logic signed [15:0] target_q8_8,
    input  logic        [7:0]  alpha_q0_8,
    output logic               valid_out,
    output logic signed [15:0] state_out_q8_8
);

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            valid_out      <= 1'b0;
            state_out_q8_8 <= '0;
        end else begin
            valid_out <= valid_in;
            if (valid_in)
                state_out_q8_8 <= relax_q8_8(state_in_q8_8, target_q8_8, alpha_q0_8);
            end
    end

endmodule
