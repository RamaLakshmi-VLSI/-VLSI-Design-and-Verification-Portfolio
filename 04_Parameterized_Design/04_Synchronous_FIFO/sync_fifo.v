`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2026 01:24:10
// Design Name: 
// Module Name: sync_fifo
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

module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8,
    parameter ADDR_WIDTH = 3   // 2^3 = 8 locations
)(
    input wire                    clk,
    input wire                    rst_n,
    
    // Write Interface
    input wire                    w_inc,   // Push request
    input wire [DATA_WIDTH-1:0]   w_data,  // Data input
    
    // Read Interface
    input wire                    r_inc,   // Pop request
    output wire [DATA_WIDTH-1:0]  r_data,  // Data output
    
    // Status Flags
    output wire                   full,
    output wire                   empty
);

    // 1. Internal Memory Array Array
    reg [DATA_WIDTH-1:0] fifo_ram [0:DEPTH-1];

    // 2. Multi-bit Pointer Registers (includes the extra Lap Counter Bit)
    reg [ADDR_WIDTH:0] w_ptr;
    reg [ADDR_WIDTH:0] r_ptr;

    // 3. Synchronous Write Pointer Tracking Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_ptr <= 0;
        end else if (w_inc && !full) begin
            w_ptr <= w_ptr + 1'b1;
        end
    end

    // 3b. Synchronous Read Pointer Tracking Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_ptr <= 0;
        end else if (r_inc && !empty) begin
            r_ptr <= r_ptr + 1'b1;
        end
    end

    // 4. Memory Array Write Operations
    always @(posedge clk) begin
        if (w_inc && !full) begin
            fifo_ram[w_ptr[ADDR_WIDTH-1:0]] <= w_data;
        end
    end

    // 5. Memory Array Asynchronous Read Operation
    assign r_data = fifo_ram[r_ptr[ADDR_WIDTH-1:0]];

    // 6. Parameterized Flag Assignments
    assign empty = (w_ptr[ADDR_WIDTH] == r_ptr[ADDR_WIDTH]) && 
                   (w_ptr[ADDR_WIDTH-1:0] == r_ptr[ADDR_WIDTH-1:0]);
                   
    assign full  = (w_ptr[ADDR_WIDTH] != r_ptr[ADDR_WIDTH]) && 
                   (w_ptr[ADDR_WIDTH-1:0] == r_ptr[ADDR_WIDTH-1:0]);

endmodule
