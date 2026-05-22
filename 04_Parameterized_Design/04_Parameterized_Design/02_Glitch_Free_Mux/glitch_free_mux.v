`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 03:10:12
// Design Name: 
// Module Name: glitch_free_mux
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

module glitch_free_mux (
    input wire clk_0,    // Clock source 0
    input wire clk_1,    // Clock source 1
    input wire sel,      // 0 chooses clk_0, 1 chooses clk_1
    input wire rst_n,    // Asynchronous active-low reset
    output wire out_clk  // The safe, glitch-free output clock
);

    reg out_0_en;
    reg out_1_en;

    // --- DOMAIN 0: Handles safe de-assertion of Clock 0 ---
    // Controlled on the negative edge of clk_0
    always @(negedge clk_0 or negedge rst_n) begin
        if (!rst_n) begin
            out_0_en <= 1'b1; // Default active on reset
        end else begin
            // It can only turn on if 'sel' is 0 AND the other clock is completely disabled
            out_0_en <= (~sel) & (~out_1_en);
        end
    end

    // --- DOMAIN 1: Handles safe assertion of Clock 1 ---
    // !!! YOUR TURN TO EDIT !!!
    // Write out the negative-edge always block for clk_1.
    // Rule: out_1_en should reset to 1'b0. 
    // On the clock edge, it should evaluate to high only when (sel) is true AND (out_0_en) is completely disabled.
    
    always @(negedge clk_1 or negedge rst_n) begin
        if (!rst_n) begin
            out_1_en <= 1'b0;
        end else begin
             out_1_en <= (sel) & (~out_0_en);
            // Complete this single assignment line:
            
        end
    end

    // --- Final Glitch-Free Clock Gating Matrix ---
    wire gated_clk_0 = clk_0 & out_0_en;
    wire gated_clk_1 = clk_1 & out_1_en;
    
    assign out_clk = gated_clk_0 | gated_clk_1;

endmodule
