`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2026 01:33:25
// Design Name: 
// Module Name: tb_sync_fifo
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

module tb_sync_fifo();

    parameter DATA_WIDTH = 8;
    parameter DEPTH      = 8;
    parameter ADDR_WIDTH = 3;

    reg                    clk;
    reg                    rst_n;
    reg                    w_inc;
    reg [DATA_WIDTH-1:0]   w_data;
    reg                    r_inc;
    wire [DATA_WIDTH-1:0]  r_data;
    wire                   full;
    wire                   empty;

    // Instantiate Design Under Test (DUT)
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .w_inc(w_inc),
        .w_data(w_data),
        .r_inc(r_inc),
        .r_data(r_data),
        .full(full),
        .empty(empty)
    );

    // Clock Generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        w_inc = 0;
        w_data = 0;
        r_inc = 0;

        // Apply Reset
        #40;
        rst_n = 1;
        #20;

        // --- TEST 1: Burst Write to Full ---
        // Pushing 8 elements into the FIFO (0x10 to 0x17)
        repeat(8) begin
            @(posedge clk);
            if (!full) begin
                w_inc = 1;
                w_data = w_data + 8'h10;
            end
        end
        
        // Try writing one more to test overflow prevention
        @(posedge clk);
        w_data = 8'hFF;
        
        // Stop Writing
        @(posedge clk);
        w_inc = 0;
        #20;

        // --- TEST 2: Burst Read to Empty ---
        repeat(8) begin
            @(posedge clk);
            if (!empty) begin
                r_inc = 1;
            end
        end
        
        // Stop Reading
        @(posedge clk);
        r_inc = 0;
        #40;

        $finish;
    end

endmodule
