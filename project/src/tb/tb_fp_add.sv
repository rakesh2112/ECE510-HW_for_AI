`timescale 1ns / 1ps

module tb_fp_add;

    // Inputs and output
    logic [31:0] a, b;
    logic [31:0] result;

    // Instantiate the adder
    fp_add uut (
        .a(a),
        .b(b),
        .result(result)
    );

    // Task to display binary and decimal float
    task print_result(string label, logic [31:0] value);
        real r;
        begin
            r = $bitstoreal({32'b0, value}); // Extend to 64 bits for $bitstoreal
            $display("%s = 0x%08x -> %f", label, value, r);
        end
    endtask

    initial begin
        $display("==== Floating-Point Adder Testbench ====\n");

        // Test 1: 3.5 + 2.25 = 5.75
        a = 32'h40600000; // 3.5
        b = 32'h40200000; // 2.25
        #10;
        $display("Test 1: 3.5 + 2.25");
        print_result("A     ", a);
        print_result("B     ", b);
        print_result("Result", result);
        $display("");

        // Test 2: -1.5 + 2.5 = 1.0
        a = 32'hBFC00000; // -1.5
        b = 32'h40200000; // 2.5
        #10;
        $display("Test 2: -1.5 + 2.5");
        print_result("A     ", a);
        print_result("B     ", b);
        print_result("Result", result);
        $display("");

        // Test 3: -2.5 + -2.5 = -5.0
        a = 32'hC0200000; // -2.5
        b = 32'hC0200000; // -2.5
        #10;
        $display("Test 3: -2.5 + -2.5");
        print_result("A     ", a);
        print_result("B     ", b);
        print_result("Result", result);
        $display("");

        // Test 4: 0.0 + 0.0 = 0.0
        a = 32'h00000000;
        b = 32'h00000000;
        #10;
        $display("Test 4: 0.0 + 0.0");
        print_result("A     ", a);
        print_result("B     ", b);
        print_result("Result", result);
        $display("");

        $display("==== Testbench Completed ====");
        $finish;
    end

endmodule

