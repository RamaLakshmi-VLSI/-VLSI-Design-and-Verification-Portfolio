`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 02:44:09
// Design Name: 
// Module Name: tb_clk_divider
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

module tb_clk_divider();

    reg clk;
    reg rst_n;
    wire clk_en_div4;
    wire clk_en_div6;

    // Instance 1: Divide by 4 configuration
    clk_divider #(.DIVIDE_BY(4)) uut_div4 (
        .clk(clk),
        .rst_n(rst_n),
        .clk_en(clk_en_div4)
    );

    // Instance 2: Divide by 6 configuration (Proves Parameter Reusability)
    clk_divider #(.DIVIDE_BY(6)) uut_div6 (
        .clk(clk),
        .rst_n(rst_n),
        .clk_en(clk_en_div6)
    );

    // 100MHz Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        rst_n = 0;
        #15;
        
        // Release Reset
        rst_n = 1;
        
        // Let the counters run for 150ns to observe multiple periodic spikes
        #150;
        
        $finish;
    end

endmodule
