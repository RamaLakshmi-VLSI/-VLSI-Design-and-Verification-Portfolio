`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2026 05:23:43
// Design Name: 
// Module Name: tb_shift_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_shift_reg();
    // Inputs to the design are registers (reg)
    reg clk;
    reg rst_n;
    reg d;
    
    // Outputs from the design are wires (wire)
    wire q_out;

    // Connect our Testbench to our 4-bit Shift Register design
    shift_reg_4bit uut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q_out(q_out)
    );

    // MASTER CLOCK GENERATOR: Flips every 5ns (10ns total period = 100MHz)
    always #5 clk = ~clk;

    initial begin
            // Step 1: Initialize and Reset
            clk = 0;
            rst_n = 0;
            d = 0;
            #12;          // Wait 12ns while reset is active
            
            // Step 2: Release Reset
            rst_n = 1;
            #8;           // Wait until 20ns (this lands right on a clock falling edge)
            
            // Step 3: Inject exactly ONE pulse that lasts a whole clock cycle
            d = 1;        // Turn d ON at 20ns
            #10;          // Hold it for 10ns (the clock will rise at 25ns and capture it!)
            d = 0;        // Turn d OFF at 30ns
            
            // Step 4: Let it run to watch it pass down the line
            #80;
            $finish;
        end
endmodule
