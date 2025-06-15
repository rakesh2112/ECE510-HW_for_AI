// ==============================================================// File: fp_add.v
// Module: fp_add
// Description: IEEE-754 compliant 32-bit Floating-Point Adder
// ==============================================================

module fp_add(
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] result
);

    // Extract sign, exponent, and mantissa
    logic sign_a, sign_b;
    logic [7:0] exp_a, exp_b;
    logic [23:0] mant_a, mant_b;

    assign sign_a = a[31];
    assign exp_a = a[30:23];
    assign mant_a = (exp_a == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};

    assign sign_b = b[31];
    assign exp_b = b[30:23];
    assign mant_b = (exp_b == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Compare exponents and align
    logic [7:0] exp_diff;
    logic [23:0] aligned_a, aligned_b;
    logic [7:0] exp_max;

    always_comb begin
        if (exp_a > exp_b) begin
            exp_diff = exp_a - exp_b;
            aligned_a = mant_a;
            aligned_b = mant_b >> exp_diff;
            exp_max = exp_a;
        end else begin
            exp_diff = exp_b - exp_a;
            aligned_a = mant_a >> exp_diff;
            aligned_b = mant_b;
            exp_max = exp_b;
        end
    end

    // Add or subtract mantissas
    logic [24:0] mant_sum;
    logic result_sign;

    always_comb begin
        if (sign_a == sign_b) begin
            mant_sum = aligned_a + aligned_b;
            result_sign = sign_a;
        end else begin
            if (aligned_a > aligned_b) begin
                mant_sum = aligned_a - aligned_b;
                result_sign = sign_a;
            end else begin
                mant_sum = aligned_b - aligned_a;
                result_sign = sign_b;
            end
        end
    end

    // Normalize result
    logic [7:0] final_exp;
    logic [22:0] final_mant;

    always_comb begin
        final_exp = exp_max;
        if (mant_sum[24]) begin
            final_mant = mant_sum[23:1];
            final_exp = exp_max + 1;
        end else begin
            final_mant = mant_sum[22:0];
        end
    end

    // Pack result
    assign result = {result_sign, final_exp, final_mant};

endmodule
