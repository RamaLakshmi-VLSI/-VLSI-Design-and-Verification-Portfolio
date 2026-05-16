`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench Name: tb_mux_2to1
// Verification Target: Exhaustive Truth Table Simulation
//////////////////////////////////////////////////////////////////////////////////

module tb_mux_2to1();

    // Inputs are declared as registers to drive values
    reg a;
    reg b;
    reg sel;
    
    // Outputs are declared as wires to sample values
    wire y;

    // Instantiate the Device Under Test (DUT)
    mux_2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        // Initialize Inputs
        a = 0; b = 0; sel = 0;
        #10;
        
        // Test Case 1: Route input A (sel = 0, expect y = a)
        a = 1; b = 0; sel = 0; #10; // y should be 1
        a = 0; b = 1; sel = 0; #10; // y should be 0
        
        // Test Case 2: Route input B (sel = 1, expect y = b)
        a = 1; b = 0; sel = 1; #10; // y should be 0
        a = 0; b = 1; sel = 1; #10; // y should be 1
        
        // Test Case 3: Both inputs high
        a = 1; b = 1; sel = 0; #10; // y should be 1
        sel = 1;               #10; // y should be 1
        
        $finish;
    end
    
endmodule
