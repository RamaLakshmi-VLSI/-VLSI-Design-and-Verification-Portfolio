`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2026 03:01:43
// Design Name: 
// Module Name: tb_decoder
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


module tb_decoder();
    reg [1:0] t_sel;
    wire [3:0] t_d;

    // Connect the decoder to our test signals
    decoder_2to4 uut ( .sel(t_sel), .d(t_d) );

    initial begin
        t_sel = 2'b00; #10; // Select line 0
        t_sel = 2'b01; #10; // Select line 1
        t_sel = 2'b10; #10; // Select line 2
        t_sel = 2'b11; #10; // Select line 3
        $finish;
    end
endmodule


