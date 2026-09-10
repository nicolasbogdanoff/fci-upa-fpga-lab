// Shared fixed-point conventions and arithmetic for the portable RTL.
package fixed_point_pkg;

    localparam int STATE_WIDTH = 16;
    localparam int ALPHA_WIDTH = 8;

    function automatic logic signed [STATE_WIDTH-1:0] saturate_q8_8(
        input logic signed [31:0] value
    );
        begin
            if (value > 32'sd32767)
                saturate_q8_8 = 16'sh7fff;
            else if (value < -32'sd32768)
                saturate_q8_8 = -16'sd32768;
            else
                saturate_q8_8 = value[STATE_WIDTH-1:0];
        end
    endfunction

    function automatic logic signed [STATE_WIDTH-1:0] relax_q8_8(
        input logic signed [STATE_WIDTH-1:0] state_q8_8,
        input logic signed [STATE_WIDTH-1:0] target_q8_8,
        input logic        [ALPHA_WIDTH-1:0] alpha_q0_8
    );
        logic signed [16:0] delta_ext;
        logic signed [25:0] product_ext;
        logic signed [31:0] candidate_ext;
        begin
            delta_ext = $signed({target_q8_8[15], target_q8_8})
                      - $signed({state_q8_8[15], state_q8_8});
            product_ext = delta_ext * $signed({1'b0, alpha_q0_8});
            candidate_ext = $signed({state_q8_8[15], state_q8_8})
                          + (product_ext >>> 8);
            relax_q8_8 = saturate_q8_8(candidate_ext);
        end
    endfunction

endpackage

