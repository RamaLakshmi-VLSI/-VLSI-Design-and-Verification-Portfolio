`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2026 04:15:39
// Design Name: 
// Module Name: dff_async_reset
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


module dff_async_reset (
    input clk,
    input rst_n,    // 'n' means active-low reset
    input d,
    output reg q    // 'reg' because it's used inside an always block
);

    // This block wakes up on Clock Rise OR Reset Fall
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0; // Immediate Reset
        end else begin
            q <= d;    // Capture Data on Clock Edge
        end
    end
endmodule