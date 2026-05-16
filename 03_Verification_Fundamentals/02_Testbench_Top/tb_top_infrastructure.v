`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_top_infrastructure
// Objective: Master Clock Generation, Reset Sequencing, and Test Benches
//////////////////////////////////////////////////////////////////////////////////

module tb_top_infrastructure();

    // 1. Global Verification Signals
    reg tb_clk;
    reg tb_rst_n;
    reg [1:0] test_vector;
    
    // 2. Clock Generation Parameters (100 MHz Clock Generation)
    // Period = 10ns -> Toggle every 5ns
    parameter CLK_PERIOD = 10;
    
    initial begin
        tb_clk = 0;
    end
    
    always #(CLK_PERIOD/2) tb_clk = ~tb_clk;

    // 3. Structured Stimulus Generation
    initial begin
        // System Initial State
        tb_rst_n = 0;
        test_vector = 2'b00;
        
        // Hold Reset for 2.5 Clock Cycles to simulate power-on stabilization
        #(CLK_PERIOD * 2.5);
        
        // Release Reset synchronously
        tb_rst_n = 1;
        
        // Apply Test Phase Vectors synchronized to the clock
        @(posedge tb_clk);
        test_vector = 2'b01;
        
        @(posedge tb_clk);
        test_vector = 2'b10;
        
        @(posedge tb_clk);
        test_vector = 2'b11;
        
        // Let the simulation settle and terminate cleanly
        #(CLK_PERIOD * 4);
        $display("Simulation successfully completed at time %0t", $time);
        $finish;
    end

endmodule
