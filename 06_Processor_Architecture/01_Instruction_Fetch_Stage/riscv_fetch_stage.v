`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 01:44:05
// Design Name: 
// Module Name: riscv_fetch_stage
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


module riscv_fetch_stage (
    input wire clk,
    input wire rst_n,
    output wire [31:0] current_pc,
    output wire [31:0] fetched_instruction
);

    // Internal wires to connect the sub-blocks
    wire [31:0] next_pc;
    wire [31:0] pc_to_mem;

    // 1. Permanent Adder Math: Next PC is always Current PC + 4
    assign next_pc = pc_to_mem + 32'd4;
    
    // Output the current PC out of the wrapper for debugging/verification
    assign current_pc = pc_to_mem;

    // 2. Instantiate your Program Counter Block
    riscv_pc u_program_counter (
        .clk   (clk),
        .rst_n (rst_n),
        .pc_in (next_pc),   // Takes the calculated PC+4
        .pc_out(pc_to_mem)  // Spits out the current address
    );

    // 3. Instantiate your Instruction Memory Block
    riscv_instruction_mem u_instruction_memory (
        .pc_addr    (pc_to_mem),           // Takes current address from PC
        .instruction(fetched_instruction)  // Spits out the 32-bit machine code
    );

endmodule
