`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2026 00:46:30
// Design Name: 
// Module Name: tb_uart_top
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

module tb_uart_top();

    reg        clk;
    reg        rst_n;
    reg        tx_start;
    reg [7:0]  tx_data;
    wire       tx;
    wire       tx_done;
    
    wire       rx;
    wire [7:0] rx_data;
    wire       rx_ready;
    wire       frame_error;

    // INTERNAL LOOPBACK MECHANISM: Wire tx directly back to rx!
    assign rx = tx;

    // Instantiate Complete Top Subsystem
    uart_top #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(115200)
    ) top_dut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done),
        .rx(rx),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .frame_error(frame_error)
    );

    // Clock Generation (50MHz -> 20ns)
    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        tx_start = 0;
        tx_data = 8'h00;

        #40;
        rst_n = 1;
        #40;

        // --- TRANSACTION: Transmit and self-receive 8'h5A ---
        @(posedge clk);
        tx_data  = 8'h5A; // Binary: 01011010
        tx_start = 1;
        
        @(posedge clk);
        tx_start = 0;

        // Wait until receiver completely rebuilds and outputs the byte
        @(posedge rx_ready);
        #200;
        
        // Let's print a check assertion directly to the console window!
        if (rx_data == 8'h5A)
            $display("SUCCESS: Transmitted 0x5A and safely captured 0x5A via loopback!");
        else
            $display("ERROR: Data mismatch! Captured: %h", rx_data);

        $finish;
    end

endmodule
