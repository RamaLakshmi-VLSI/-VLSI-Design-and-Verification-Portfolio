`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2026 06:10:40
// Design Name: 
// Module Name: tb_system_ctrl
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

module tb_system_ctrl();

    // Inputs to DUT
    reg clk;
    reg rst_n;
    reg [1:0] cmd;

    // Outputs from DUT
    wire read_en;
    wire write_en;

    // Instantiate the FSM
    system_ctrl uut (
        .clk(clk),
        .rst_n(rst_n),
        .cmd(cmd),
        .read_en(read_en),
        .write_en(write_en)
    );

    // 100MHz Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize System
        clk = 0;
        rst_n = 0;
        cmd = 2'b00;
        #15;
        
        // Release Reset
        rst_n = 1;
        #10;
        
        // Command Phase 1: Go to READ mode
        cmd = 2'b01; 
        #20; // Hold in READ for 2 clock cycles
        
        // Command Phase 2: Return to IDLE
        cmd = 2'b00;
        #20;
        
        // Command Phase 3: Go to WRITE mode
        cmd = 2'b10;
        #30; // Hold in WRITE for 3 clock cycles
        
        // Return to IDLE and finish
        cmd = 2'b00;
        #20;
        
        $finish;
    end

endmodule
