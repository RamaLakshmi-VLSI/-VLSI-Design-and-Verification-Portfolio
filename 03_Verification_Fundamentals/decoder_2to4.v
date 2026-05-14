`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2026 02:52:30
// Design Name: 
// Module Name: decoder_2to4
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


module decoder_2to4 (
    input [1:0] sel,
    output [3:0] d
);
    assign d[0] = ~sel[1] & ~sel[0];
    assign d[1] = ~sel[1] &  sel[0];
    assign d[2] =  sel[1] & ~sel[0];
    assign d[3] =  sel[1] &  sel[0];
endmodule
