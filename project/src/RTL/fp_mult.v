// ==============================================================// File: fp_mult.v
// Module: fp_mult
// Description: IEEE-754 compliant 32-bit Floating-Point Multiplier
// ==============================================================

module fp_mult(
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

    // Calculate sign of result
    logic sign_res;
    assign sign_res = sign_a ^ sign_b;

    // Add exponents and subtract bias (127)
    logic [8:0] exp_sum;
    assign exp_sum = exp_a + exp_b - 8'd127;

    // Multiply mantissas (24x24 = 48 bits)
    logic [47:0] mant_prod;
    assign mant_prod = mant_a * mant_b;

    // Normalize the result mantissa
    logic [7:0] final_exp;
    logic [22:0] final_mant;

    always_comb begin
        if (mant_prod[47]) begin
            final_mant = mant_prod[46:24];
            final_exp  = exp_sum + 1;
        end else begin
            final_mant = mant_prod[45:23];
            final_exp  = exp_sum;
        end
    end

    // Pack the result
    assign result = {sign_res, final_exp, final_mant};

endmodule
