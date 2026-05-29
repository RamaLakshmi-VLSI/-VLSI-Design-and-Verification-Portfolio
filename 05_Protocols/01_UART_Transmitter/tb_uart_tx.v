`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 18:48:08
// Design Name: 
// Module Name: tb_uart_tx
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

module tb_uart_tx();

    reg        clk;
    reg        rst_n;
    reg        tx_start;
    reg [7:0]  tx_data;
    wire       tx;
    wire       tx_done;

    // Instantiate Transmitter Unit Under Test
    uart_tx #(
        .CLK_FREQ(50000000),  // 50 MHz
        .BAUD_RATE(115200)    // 115200 Baud
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done)
    );

    // System Clock Generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        rst_n = 0;
        tx_start = 0;
        tx_data = 8'h00;

        // Release Reset
        #40;
        rst_n = 1;
        #40;

        // --- TRANSMIT TRANSACTION ---
        @(posedge clk);
        tx_data  = 8'hA5; // Binary: 10100101
        tx_start = 1;     // Pulse start signal
        
        @(posedge clk);
        tx_start = 0;     // Clear start flag immediately

        // Monitor transaction completion
        @(posedge tx_done);
        #200;
        
        $finish;
    end

endmodule
