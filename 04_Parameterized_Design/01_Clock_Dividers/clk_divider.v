`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 02:16:25
// Design Name: 
// Module Name: clk_divider
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

module clk_divider #(
    parameter DIVIDE_BY = 4 // Compile-time configurable division factor
)(
    input wire clk,
    input wire rst_n,
    output reg clk_en    // The clean strobe pulse output
);

    // Calculate how many bits we need for the counter automatically
    // For DIVIDE_BY = 4, we need to count from 0 up to 3 (2'b11), so a 2-bit counter is perfect.
    reg [$clog2(DIVIDE_BY)-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count  <= 0;
            clk_en <= 1'b0;
        end else begin
        
            // !!! YOUR TURN !!!
            // Step 1: Check if the counter has reached its terminal value: (DIVIDE_BY - 1)
            // Step 2: If it hits the limit, reset 'count' to 0 and drive 'clk_en' high (1'b1)
            // Step 3: Otherwise, increment 'count' by 1 and drive 'clk_en' low (1'b0)
            
            if (count == (DIVIDE_BY - 1)) begin
                count  <= 0;
                clk_en <= 1'b1;
            end else begin
                count <= count+1;
                clk_en <=1'b0;// Complete the 'else' condition lines here:
            end
        end
    end

endmodule
