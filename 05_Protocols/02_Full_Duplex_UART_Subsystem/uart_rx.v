`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2026 00:32:55
// Design Name: 
// Module Name: uart_rx
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

module uart_rx #(
    parameter CLK_FREQ   = 50000000, // 50 MHz
    parameter BAUD_RATE  = 115200,
    // Clocks per oversampling tick: 50MHz / (115200 * 16) = 27
    parameter CLK_PER_TICK = CLK_FREQ / (BAUD_RATE * 16)
)(
    input wire         clk,
    input wire         rst_n,
    input wire         rx,          // Physical asynchronous input wire
    output reg [7:0]   rx_data,     // Parallel byte output for CPU
    output reg         rx_ready,    // Push pulse indicating data is valid
    output reg         frame_error  // Flag raised if stop bit is corrupt
);

    // FSM State Encoding
    localparam STATE_IDLE  = 2'b00;
    localparam STATE_START = 2'b01;
    localparam STATE_DATA  = 2'b10;
    localparam STATE_STOP  = 2'b11;

    reg [1:0] current_state, next_state;

    // 1. Double-Flop Synchronizer Registers (Meta-stability Shield)
    reg rx_sync_1;
    reg rx_sync_2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_sync_1 <= 1'b1;
            rx_sync_2 <= 1'b1;
        end else begin
            rx_sync_1 <= rx;
            rx_sync_2 <= rx_sync_1; // Clean synchronous line to read from
        end
    end

    // Internal tracking counters
    reg [4:0] clk_count;    // Counts up to 27 to generate the oversampling pulse
    reg [3:0] tick_count;   // Tracks the 16 oversampling ticks within a single bit
    reg [2:0] bit_index;    // Tracks which data bit (0 to 7) is being shifted in
    reg [7:0] rx_shift_reg; // Temporary register assembling the bits
    
    wire baud_tick = (clk_count == CLK_PER_TICK - 1);

    // 2. High-speed Baud Tick Generator (Ticks every 27 clock cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_count <= 0;
        end else if (current_state != STATE_IDLE) begin
            if (clk_count < CLK_PER_TICK - 1)
                clk_count <= clk_count + 1'b1;
            else
                clk_count <= 0;
        end else begin
            clk_count <= 0;
        end
    end

    // 3. Sequential State Machine & Data Routing Path
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STATE_IDLE;
            tick_count    <= 0;
            bit_index     <= 0;
            rx_shift_reg  <= 0;
            rx_data       <= 0;
            rx_ready      <= 0;
            frame_error   <= 0;
        end else begin
            rx_ready <= 1'b0; // Default pulse low
            
            case (current_state)
                STATE_IDLE: begin
                    tick_count  <= 0;
                    bit_index   <= 0;
                    // Detect falling edge on the synchronized rx wire
                    if (rx_sync_2 == 1'b0) begin
                        current_state <= STATE_START;
                    end
                end

                STATE_START: begin
                    if (baud_tick) begin
                        if (tick_count == 7) begin // Exact middle of Start Bit
                            if (rx_sync_2 == 1'b0) begin // Verify it is still low
                                tick_count    <= 0;
                                current_state <= STATE_DATA;
                            end else begin
                                current_state <= STATE_IDLE; // False start glitch
                            end
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end

                STATE_DATA: begin
                    if (baud_tick) begin
                        if (tick_count == 15) begin // Hit the middle of the payload bit
                            tick_count <= 0;
                            rx_shift_reg[bit_index] <= rx_sync_2; // Sample and store
                            
                            if (bit_index < 7) begin
                                bit_index <= bit_index + 1'b1;
                            end else begin
                                bit_index     <= 0;
                                current_state <= STATE_STOP;
                            end
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end

                STATE_STOP: begin
                    if (baud_tick) begin
                        if (tick_count == 15) begin // Center of Stop Bit window
                            if (rx_sync_2 == 1'b1) begin // Must be high to be valid
                                rx_data     <= rx_shift_reg;
                                rx_ready    <= 1'b1; // Output valid data to CPU
                                frame_error <= 1'b0;
                            end else begin
                                frame_error <= 1'b1; // Stop bit missing! Frame broke.
                            end
                            current_state <= STATE_IDLE;
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end
            endcase
        end
    end

endmodule
