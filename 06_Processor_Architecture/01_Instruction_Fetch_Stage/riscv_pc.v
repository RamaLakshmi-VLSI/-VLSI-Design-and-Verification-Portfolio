`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 01:50:56
// Design Name: 
// Module Name: riscv_pc
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

module riscv_pc (
    input wire        clk,
    input wire        rst_n,
    input wire        branch_taken,       // High if we need to jump
    input wire [31:0] branch_target_addr, // The jump location
    output reg [31:0] pc_out              // Current instruction pointer
);

    // Internal wire to hold the calculated sequential next address (PC + 4)
    wire [31:0] pc_plus_4 = pc_out + 4;
    
    // Internal wire representing the input to the PC register (the MUX output)
    wire [31:0] next_pc;

    // Combinational MUX selection logic
    assign next_pc = (branch_taken) ? branch_target_addr : pc_plus_4;

    // !!! YOUR TASK !!!
    // Write the sequential always block triggered on the positive edge of the clock 
    // or the negative edge of the reset signal (rst_n).
    always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                pc_out <= 32'd0;       // Reset all 32 bits of the address pointer to zero
            end else begin
                pc_out <= next_pc;     // Update the register with the calculated next address
            end
        end
       

endmodule
