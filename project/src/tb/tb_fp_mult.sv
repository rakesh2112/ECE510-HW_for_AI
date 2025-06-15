`timescale 1ns / 1ps

module tb_fp_mult;

    logic [31:0] a, b;
    logic [31:0] result;

    // Instantiate the multiplier
    fp_mult uut (
        .a(a),
        .b(b),
        .result(result)
    );

    // Utility task to print float value from 32-bit IEEE-754
    task print_float(string label, logic [31:0] bits);
        real val;
        begin
            val = $bitstoreal({32'b0, bits});
            $display("%s = 0x%08x -> %f", label, bits, val);
        end
    endtask

    initial begin
        $display("==== Floating-Point Multiplier Testbench ====\n");

        // Test 1: 2.0 * 4.0 = 8.0
        a = 32'h40000000; // 2.0
        b = 32'h40800000; // 4.0
        #10;
        $display("Test 1: 2.0 * 4.0");
        print_float("A     ", a);
        print_float("B     ", b);
        print_float("Result", result);
        $display("");

        // Test 2: -1.5 * 3.0 = -4.5
        a = 32'hBFC00000; // -1.5
        b = 32'h40400000; // 3.0
        #10;
        $display("Test 2: -1.5 * 3.0");
        print_float("A     ", a);
        print_float("B     ", b);
        print_float("Result", result);
        $display("");

        // Test 3: 0.0 * 5.0 = 0.0
        a = 32'h00000000; // 0.0
        b = 32'h40A00000; // 5.0
        #10;
        $display("Test 3: 0.0 * 5.0");
        print_float("A     ", a);
        print_float("B     ", b);
        print_float("Result", result);
        $display("");

        // Test 4: -2.5 * -2.5 = 6.25
        a = 32'hC0200000; // -2.5
        b = 32'hC0200000; // -2.5
        #10;
        $display("Test 4: -2.5 * -2.5");
        print_float("A     ", a);
        print_float("B     ", b);
        print_float("Result", result);
        $display("");

        $display("==== Testbench Complete ====");
        $finish;
    end

endmodule