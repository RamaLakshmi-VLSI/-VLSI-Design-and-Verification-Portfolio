`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2026 07:03:21
// Design Name: 
// Module Name: mux_2to1
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


module mux_2to1(
    input wire a,      // Data Input 0
    input wire b,      // Data Input 1
    input wire sel,    // Select Line
    output reg y       // Output Data
);

    // Behavioral modeling of a combinational multiplexer
    always @(*) begin
        if (sel == 1'b1) begin
            y = b;     // If sel is 1, route input b to output
        end else begin
            y = a;     // If sel is 0, route input a to output
        end
    end
endmodule
