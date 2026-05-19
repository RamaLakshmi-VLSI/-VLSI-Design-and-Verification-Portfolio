`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2026 06:15:19
// Design Name: 
// Module Name: tb_seq_detector_1101
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


`timescale 1ns / 1ps

module tb_seq_detector_1101();

    reg clk;
    reg rst_n;
    reg din;
    wire dout;

    // Instantiate the Sequence Detector
    seq_detector_1101 uut (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .dout(dout)
    );

    // 100MHz Clock Generation (Period = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        rst_n = 0;
        din = 0;
        #15;
        
        // Release Reset
        rst_n = 1;
        #5; // Align with clock margins
        
        // --- Test Sequence 1: Feed a clean '1101' pattern ---
        @(posedge clk); din = 1; // Bit 1 -> Moves to STATE_1
        @(posedge clk); din = 1; // Bit 2 -> Moves to STATE_11
        @(posedge clk); din = 0; // Bit 3 -> Moves to STATE_110
        @(posedge clk); din = 1; // Bit 4 -> Moves to STATE_1101 (dout should flash high here!)
        
        // --- Let it clear out ---
        @(posedge clk); din = 0; // Clears back to IDLE
        #20;
        
        // --- Test Sequence 2: A broken pattern '1100' to test reset fallback ---
        @(posedge clk); din = 1; // STATE_1
        @(posedge clk); din = 1; // STATE_11
        @(posedge clk); din = 0; // STATE_110
        @(posedge clk); din = 0; // Broken! Should kick back to IDLE
        
        // --- Test Sequence 3: Direct back-to-back testing ---
        @(posedge clk); din = 1; // STATE_1
        @(posedge clk); din = 1; // STATE_11
        @(posedge clk); din = 0; // STATE_110
        @(posedge clk); din = 1; // Success! STATE_1101 (dout = 1)
        
        @(posedge clk); din = 0; // Back to IDLE
        #40;
        $finish;
    end
      
endmodule
