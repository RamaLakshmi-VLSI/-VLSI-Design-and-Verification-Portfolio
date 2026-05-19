`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2026 07:20:04
// Design Name: 
// Module Name: tb_seq_detector_overlap
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

module tb_seq_detector_overlap();

    reg clk;
    reg rst_n;
    reg din;
    wire dout;

    // Instantiate FSM
    seq_detector_1101 uut (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .dout(dout)
    );

    // 100MHz Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        din = 0;
        #15;
        
        rst_n = 1; // Release reset
        #10;
        
        // --- STREAMING OVERLAPPING PATTERN: 1101101 ---
        din = 1; #10; // Bit 1 -> Moves to STATE_1
        din = 1; #10; // Bit 2 -> Moves to STATE_11
        din = 0; #10; // Bit 3 -> Moves to STATE_110
        din = 1; #10; // Bit 4 -> Moves to STATE_1101 (dout should flash high here!)
        
        // Next bit arrives while we are in STATE_1101!
        din = 1; #10; // Bit 5 -> Overlaps! Should move back to STATE_11 instead of IDLE
        din = 0; #10; // Bit 6 -> Moves to STATE_110
        din = 1; #10; // Bit 7 -> Matches again! (dout should flash high a second time)
        
        din = 0; #20; // Clear out stream
        $finish;
    end

endmodule
