`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2026 00:09:40
// Design Name: 
// Module Name: dual_port_reg_file
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

module dual_port_reg_file #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 8,
    parameter ADDR_WIDTH = 3   // 2^3 = 8 locations
)(
    input wire                     clk,
    input wire                     rst_n,
    
    // Write Port
    input wire                     we,
    input wire [ADDR_WIDTH-1:0]    w_addr,
    input wire [DATA_WIDTH-1:0]    w_data,
    
    // Read Port A
    input wire [ADDR_WIDTH-1:0]    r_addr_a,
    output wire [DATA_WIDTH-1:0]   r_data_a,
    
    // Read Port B
    input wire [ADDR_WIDTH-1:0]    r_addr_b,
    output wire [DATA_WIDTH-1:0]   r_data_b
);

    // 1. Declare the 2D Memory Array
    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    integer i;

    // 2. Synchronous Write Port Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Structural loop to clear all memory locations on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                memory[i] <= {DATA_WIDTH{1'b0}};
            end
        end else if (we) begin
            memory[w_addr] <= w_data;
        end
    end

    // 3. Read Port A with Write-Before-Read Data Forwarding (Bypass)
    assign r_data_a = (we && (r_addr_a == w_addr)) ? w_data : memory[r_addr_a];
       
    assign r_data_b = (we && (r_addr_b == w_addr)) ? w_data : memory[r_addr_b];
    
    //If write enable (we) is active AND r_addr_b equals w_addr, forward w_data directly. Otherwise, output the value inside memory[r_addr_b].
    
    

endmodule

