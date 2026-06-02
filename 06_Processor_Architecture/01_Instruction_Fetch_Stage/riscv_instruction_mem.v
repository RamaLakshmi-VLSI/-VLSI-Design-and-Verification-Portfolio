`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 02:20:40
// Design Name: 
// Module Name: riscv_instruction_mem
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

module riscv_instruction_mem (
    input wire [31:0]  instruction_addr, // 32-bit address input from PC
    output wire [31:0] instruction_out  // 32-bit fetched instruction output
);

    // Create a memory array of 64 slots, where each slot is 32 bits wide
    reg [31:0] rom_memory [0:63];

    // Word-alignment: Drop the lowest 2 bits to divide the byte address by 4.
    // Example: Address 0000 (0) -> Array Index 0
    //          Address 0100 (4) -> Array Index 1
    //          Address 1000 (8) -> Array Index 2
    wire [5:0] rom_index = instruction_addr[7:2];

    // Continuously read the instruction at the calculated index slot
        assign instruction_out = rom_memory[rom_index];
endmodule
