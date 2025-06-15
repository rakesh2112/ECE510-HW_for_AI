module matrix_vector_mul_fp #(
    parameter int M = 2,  // output rows
    parameter int N = 4   // input features (must be power of 2)
)(
    input  logic         clk,
    input  logic         rst,
    input  logic         start,
    input  logic [31:0]  matrix [M][N],
    input  logic [31:0]  vector [N],
    output logic [31:0]  result [M],
    output logic         done
);

    logic [31:0] products [M][N];
    logic        compute_pending;

    // ===========================
    // 1. Multiplier instances
    // ===========================
    genvar i, j;
    generate
        for (i = 0; i < M; i++) begin: ROWS
            for (j = 0; j < N; j++) begin: COLS
                fp_mult mul_inst (
                    .a(matrix[i][j]),
                    .b(vector[j]),
                    .result(products[i][j])
                );
            end
        end
    endgenerate

    // ===========================
    // 2. Adder tree and result register
    // ===========================
    generate
        for (i = 0; i < M; i++) begin: ADD_ROWS
            logic [31:0] sum0, sum1;
            logic [31:0] sum_final;

            fp_add add0 (.a(products[i][0]), .b(products[i][1]), .result(sum0));
            fp_add add1 (.a(products[i][2]), .b(products[i][3]), .result(sum1));
            fp_add add2 (.a(sum0),           .b(sum1),           .result(sum_final));

            // Register result 1 cycle after start
            always_ff @(posedge clk or posedge rst) begin
                if (rst)
                    result[i] <= 32'b0;
                else if (compute_pending)
                    result[i] <= sum_final;
            end
        end
    endgenerate

    // ===========================
    // 3. Control FSM
    // ===========================
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            compute_pending <= 0;
            done <= 0;
        end else begin
            compute_pending <= start;
            done <= compute_pending; // delay done by 1 cycle
        end
    end

endmodule