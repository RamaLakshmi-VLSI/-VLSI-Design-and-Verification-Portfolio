`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2026 04:17:49
// Design Name: 
// Module Name: tb_dff
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


module tb_dff();
    reg clk, rst_n, d;
    wire q;

    dff_async_reset uut (.clk(clk), .rst_n(rst_n), .d(d), .q(q));

    // GENERATE CLOCK: Flips every 5ns
    always #5 clk = ~clk; //This creates a clock with a 10ns period (5ns at '0', 5ns at '1'). In the VLSI world, this is a 100MHz clock. Most entry-level internship projects run at this speed.

    initial begin
        clk = 0; rst_n = 0; d = 0; #12; 
        rst_n = 1; // Release reset
        #10 d = 1; // Set data to 1
        #10 d = 0; // Set data to 0
        #20 $finish;
    end
endmodule
