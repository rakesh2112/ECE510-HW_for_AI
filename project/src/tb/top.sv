// =============================================================
// tb_matrix_vector_mul_fp_parallel_debug_fixed.sv
// Fixed version using shortreal for IEEE-754 compatibility
// =============================================================

/*`timescale 1ns/1ps

module tb_matrix_vector_mul_fp;

    parameter M = 2;
    parameter N = 4;

    logic clk;
    logic rst;
    logic start;
    logic [31:0] matrix [0:M-1][0:N-1];
    logic [31:0] vector [0:N-1];
    logic [31:0] result [0:M-1];
    logic done;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Instantiate the DUT
    matrix_vector_mul_fp #(.M(M), .N(N)) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .matrix(matrix),
        .vector(vector),
        .result(result),
        .done(done)
    );

    // IEEE-754 conversion for float to hex (using shortreal)
    function [31:0] float_to_bits(input shortreal val);
        float_to_bits = $shortrealtobits(val);
    endfunction

    function shortreal bits_to_float(input [31:0] bits);
        bits_to_float = $bitstoshortreal(bits);
    endfunction

    // Test stimulus
    initial begin
        $display("=== Floating-Point Matrix-Vector Multiplication Testbench ===");
        rst = 1;
        start = 0;
        #20;
        rst = 0;

        // Initialize inputs
        matrix[0][0] = float_to_bits(1.0);
        matrix[0][1] = float_to_bits(2.0);
        matrix[0][2] = float_to_bits(3.0);
        matrix[0][3] = float_to_bits(4.0);

        matrix[1][0] = float_to_bits(5.0);
        matrix[1][1] = float_to_bits(6.0);
        matrix[1][2] = float_to_bits(7.0);
        matrix[1][3] = float_to_bits(8.0);

        vector[0] = float_to_bits(1.0);
        vector[1] = float_to_bits(1.0);
        vector[2] = float_to_bits(1.0);
        vector[3] = float_to_bits(1.0);

        $display("Matrix and vector inputs:");
        for (int r = 0; r < M; r++) begin
            $write("Row %0d: ", r);
            for (int c = 0; c < N; c++) begin
                $write("%f ", bits_to_float(matrix[r][c]));
            end
            $display("");
        end

        $write("Vector: ");
        for (int i = 0; i < N; i++) begin
            $write("%f ", bits_to_float(vector[i]));
        end
        $display("");

        #10;
        start = 1;
        #10;
        start = 0;

        $display("Waiting for done...");
        while (!done) begin
            @(posedge clk);
        end

        $display("? DONE received. Output:");
        for (int i = 0; i < M; i++) begin
            $display(" result[%0d] = %f", i, bits_to_float(result[i]));
        end

        $display("============================================================");
        $finish;
    end

endmodule
*/
`timescale 1ns/1ps

module tb_matrix_vector_mul_fp;

    parameter M = 2;
    parameter N = 4;

    logic clk;
    logic rst;
    logic start;
    logic [31:0] matrix [0:M-1][0:N-1];
    logic [31:0] vector [0:N-1];
    logic [31:0] result [0:M-1];
    logic done;

    // Predefined test matrices and vectors
    shortreal mat1[M][N] = '{'{1.0, 2.0, 3.0, 4.0},
                             '{5.0, 6.0, 7.0, 8.0}};
    shortreal vec1[N]    = '{1.0, 1.0, 1.0, 1.0};

    shortreal mat2[M][N] = '{'{0.5, -1.5, 2.0, 0.0},
                             '{-2.0, 3.5, 1.0, 4.0}};
    shortreal vec2[N]    = '{2.0, 0.5, -1.0, 3.0};

    shortreal mat3[M][N] = '{'{-3.0, -2.0, -1.0, 0.0},
                             '{0.0, 1.0, 2.0, 3.0}};
    shortreal vec3[N]    = '{1.0, 2.0, 3.0, 4.0};

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT instantiation
    matrix_vector_mul_fp #(.M(M), .N(N)) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .matrix(matrix),
        .vector(vector),
        .result(result),
        .done(done)
    );

    // Conversion functions
    function [31:0] float_to_bits(input shortreal val);
        return $shortrealtobits(val);
    endfunction

    function shortreal bits_to_float(input [31:0] bits);
        return $bitstoshortreal(bits);
    endfunction

    // Task to run a test
    task run_testcase(input string label,
                      input shortreal mat_in [0:M-1][0:N-1],
                      input shortreal vec_in [0:N-1]);
        begin
            $display("\n[TESTCASE] %s", label);
            rst = 1;
            start = 0;
            #10 rst = 0;

            // Load inputs
            for (int i = 0; i < M; i++)
                for (int j = 0; j < N; j++)
                    matrix[i][j] = float_to_bits(mat_in[i][j]);

            for (int i = 0; i < N; i++)
                vector[i] = float_to_bits(vec_in[i]);

            // Display inputs
            $display("Matrix:");
            for (int i = 0; i < M; i++) begin
                $write("  Row %0d: ", i);
                for (int j = 0; j < N; j++)
                    $write("%6.2f ", mat_in[i][j]);
                $display("");
            end

            $write("Vector: ");
            for (int i = 0; i < N; i++)
                $write("%6.2f ", vec_in[i]);
            $display("");

            // Start computation
            #10 start = 1;
            #10 start = 0;

            // Wait for done
            @(posedge done);
            #1;

            // Output result
            $display("Output:");
            for (int i = 0; i < M; i++)
                $display("  result[%0d] = %f", i, bits_to_float(result[i]));
        end
    endtask

    // Run all tests
    initial begin
        $display("=== Floating-Point Matrix-Vector Multiplication Testbench ===");

        run_testcase("All Ones Vector", mat1, vec1);
        run_testcase("Mixed Signs",     mat2, vec2);
        run_testcase("Negative Matrix", mat3, vec3);

        $display("\n=== Testbench Complete ===");
        $finish;
    end

endmodule
