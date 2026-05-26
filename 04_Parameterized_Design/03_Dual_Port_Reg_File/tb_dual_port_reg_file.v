`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2026 00:24:37
// Design Name: 
// Module Name: tb_dual_port_reg_file
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

module tb_dual_port_reg_file();

    parameter DATA_WIDTH = 32;
    parameter DEPTH      = 8;
    parameter ADDR_WIDTH = 3;

    reg                     clk;
    reg                     rst_n;
    reg                     we;
    reg [ADDR_WIDTH-1:0]    w_addr;
    reg [DATA_WIDTH-1:0]    w_data;
    reg [ADDR_WIDTH-1:0]    r_addr_a;
    wire [DATA_WIDTH-1:0]   r_data_a;
    reg [ADDR_WIDTH-1:0]    r_addr_b;
    wire [DATA_WIDTH-1:0]   r_data_b;

    // Instantiate the Design Under Test (DUT)
    dual_port_reg_file #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .w_addr(w_addr),
        .w_data(w_data),
        .r_addr_a(r_addr_a),
        .r_data_a(r_data_a),
        .r_addr_b(r_addr_b),
        .r_data_b(r_data_b)
    );

    // Clock Generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        we = 0;
        w_addr = 0;
        w_data = 0;
        r_addr_a = 0;
        r_addr_b = 0;

        // Hold Reset for 40ns
        #40;
        rst_n = 1;
        #20;

        // --- TEST 1: Write Data to Locations 2 and 5 ---
        @(posedge clk);
        we = 1; w_addr = 3'd2; w_data = 32'hDEAD_BEEF;
        
        @(posedge clk);
        we = 1; w_addr = 3'd5; w_data = 32'hCAFE_BABE;

        // Turn off write enable
        @(posedge clk);
        we = 0;

        // --- TEST 2: Simultaneous Parallel Read ---
        // Port A reads address 2, Port B reads address 5 at the same time
        @(posedge clk);
        r_addr_a = 3'd2;
        r_addr_b = 3'd5;
        
        // --- TEST 3: Write-Before-Read Collision (Data Forwarding) ---
        // Writing 32'hAAAA_BBBB to address 4, while Port A tries to read address 4 simultaneously
        @(posedge clk);
        we = 1; w_addr = 3'd4; w_data = 32'hAAAA_BBBB;
        r_addr_a = 3'd4; 
        r_addr_b = 3'd2; // Port B just continues reading address 2

        #40;
        $finish;
    end

endmodule
