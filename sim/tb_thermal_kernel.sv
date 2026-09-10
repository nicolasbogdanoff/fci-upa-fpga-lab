`timescale 1ns/1ps

module tb_thermal_kernel;
    logic               clk = 1'b0;
    logic               reset_n = 1'b0;
    logic               start = 1'b0;
    logic signed [15:0] state_in_q8_8;
    logic signed [15:0] target_q8_8;
    logic        [7:0]  alpha_q0_8;
    logic               busy;
    logic               done;
    logic signed [15:0] state_out_q8_8;

    always #5 clk = ~clk;

    thermal_kernel dut (.*);

    task automatic run_case(
        input integer state_value,
        input integer target_value,
        input integer alpha_value,
        input integer expected_value
    );
        begin
            @(negedge clk);
            state_in_q8_8 = state_value;
            target_q8_8   = target_value;
            alpha_q0_8    = alpha_value;
            start         = 1'b1;

            @(negedge clk);
            start = 1'b0;
            wait (done === 1'b1);

            if ($signed(state_out_q8_8) !== expected_value) begin
                $display("FAIL state=%0d target=%0d alpha=%0d got=%0d expected=%0d",
                         state_value, target_value, alpha_value,
                         $signed(state_out_q8_8), expected_value);
                $fatal(1);
            end

            $display("PASS state=%0d target=%0d alpha=%0d result=%0d",
                     state_value, target_value, alpha_value,
                     $signed(state_out_q8_8));
        end
    endtask

    initial begin
        state_in_q8_8 = '0;
        target_q8_8   = '0;
        alpha_q0_8    = '0;

        repeat (2) @(negedge clk);
        reset_n = 1'b1;

        run_case(0, 256, 64, 64);
        run_case(64, 256, 128, 160);
        run_case(-512, 512, 64, -256);
        run_case(30000, -32768, 255, -32523);

        $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
