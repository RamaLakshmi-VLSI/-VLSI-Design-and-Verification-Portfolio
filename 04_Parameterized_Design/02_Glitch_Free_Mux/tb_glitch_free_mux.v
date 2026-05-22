`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 03:15:55
// Design Name: 
// Module Name: tb_glitch_free_mux
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

module tb_glitch_free_mux();

    reg clk_0;
    reg clk_1;
    reg sel;
    reg rst_n;
    wire out_clk;

    // Instantiate the Glitch-Free Mux
    glitch_free_mux uut (
        .clk_0(clk_0),
        .clk_1(clk_1),
        .sel(sel),
        .rst_n(rst_n),
        .out_clk(out_clk)
    );

    // Clock 0: High frequency (20ns period -> 50 MHz)
    always #10 clk_0 = ~clk_0;

    // Clock 1: Low frequency (50ns period -> 20 MHz) - Offset slightly to simulate separate asynchronous roots
    always #25 clk_1 = ~clk_1;

    initial begin
        // Initialize
        clk_0 = 0;
        clk_1 = 0;
        sel = 0;
        rst_n = 0;
        #35;
        
        rst_n = 1; // Release reset
        #60;
        
        // --- TEST 1: Switch from clk_0 to clk_1 mid-cycle ---
        // Intentionally changing 'sel' asynchronously relative to both clock sources
        sel = 1; 
        #150;
        
        // --- TEST 2: Switch back from clk_1 to clk_0 ---
        sel = 0;
        #150;
        
        $finish;
    end

endmodule
