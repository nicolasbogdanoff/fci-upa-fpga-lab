`timescale 1ns/1ps

module tb_thermal_kernel_stream;
    logic               clk = 1'b0;
    logic               reset_n = 1'b0;
    logic               valid_in = 1'b0;
    logic signed [15:0] state_in_q8_8 = '0;
    logic signed [15:0] target_q8_8 = '0;
    logic        [7:0]  alpha_q0_8 = '0;
    logic               valid_out;
    logic signed [15:0] state_out_q8_8;

    integer states [0:5] = '{0, 64, -512, 30000, -20000, 1000};
    integer targets [0:5] = '{256, 256, 512, -32768, 16000, -1000};
    integer alphas [0:5] = '{64, 128, 64, 255, 32, 192};
    integer expected [0:5] = '{64, 160, -256, -32523, -15500, -500};
    integer input_index = 0;
    integer output_index = 0;

    always #5 clk = ~clk;

    thermal_kernel_stream dut (.*);

    always @(posedge clk) begin
        #1;
        if (valid_out) begin
            if ($signed(state_out_q8_8) !== expected[output_index]) begin
                $display("FAIL stream index=%0d got=%0d expected=%0d",
                         output_index, $signed(state_out_q8_8), expected[output_index]);
                $fatal(1);
            end
            $display("PASS stream index=%0d result=%0d",
                     output_index, $signed(state_out_q8_8));
            output_index = output_index + 1;
        end
    end

    initial begin
        repeat (2) @(negedge clk);
        reset_n = 1'b1;

        for (input_index = 0; input_index < 6; input_index = input_index + 1) begin
            @(negedge clk);
            state_in_q8_8 = states[input_index];
            target_q8_8   = targets[input_index];
            alpha_q0_8    = alphas[input_index];
            valid_in      = 1'b1;
        end

        @(negedge clk);
        valid_in = 1'b0;
        repeat (2) @(negedge clk);

        if (output_index != 6) begin
            $display("FAIL stream count got=%0d expected=6", output_index);
            $fatal(1);
        end
        $display("ALL STREAM TESTS PASSED");
        $finish;
    end
endmodule
