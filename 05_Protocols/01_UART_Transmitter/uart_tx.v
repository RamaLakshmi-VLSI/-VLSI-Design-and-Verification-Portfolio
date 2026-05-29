`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 18:32:43
// Design Name: 
// Module Name: uart_tx
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

module uart_tx #(
    parameter CLK_FREQ   = 50000000, // 50 MHz system clock
    parameter BAUD_RATE  = 115200,   // Target communication speed
    
    // Derived Timing Const: Clocks per bit (50MHz / 115200 = 434)
    parameter CLK_PER_BIT = CLK_FREQ / BAUD_RATE 
)(
    input wire       clk,
    input wire       rst_n,
    input wire       tx_start, // CPU pulse to start transmission
    input wire [7:0] tx_data,  // 8-bit parallel byte from CPU
    output reg       tx,       // 1-bit physical serial output wire
    output reg       tx_done   // Status flag: transmission complete
);

    // State Encoding using standard localparams
    localparam STATE_IDLE  = 2'b00;
    localparam STATE_START = 2'b01;
    localparam STATE_DATA  = 2'b10;
    localparam STATE_STOP  = 2'b11;

    reg [1:0]  current_state, next_state;
    
    // Registers for tracking timing and bit indices
    reg [8:0]  clk_count; // 9 bits wide (can count up to 511, perfect for 434)
    reg [2:0]  bit_index; // 3 bits wide (can count 0 to 7 for data serialization)
    reg [7:0]  tx_data_reg; // Internal buffer to hold data stable during tx

    // 1. Sequential State Memory Control Loop
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STATE_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // 2. Combinational Next-State Logic & Signal Control
   
    // Analyze how the FSM moves through the packet frames based on the timing delays.
    always @(*) begin
        next_state = current_state; // Default hold state
        
        case (current_state)
            STATE_IDLE: begin
                if (tx_start) 
                    next_state = STATE_START;
            end
            
            STATE_START: begin
                // Stay in START state for exactly 434 cycles to fulfill Start Bit duration
                if (clk_count == CLK_PER_BIT - 1)
                    next_state = STATE_DATA;
            end
            
            STATE_DATA: begin
                // Stay here until all 8 bits are sent (each bit lasting 434 cycles)
                if (clk_count == CLK_PER_BIT - 1 && bit_index == 7)
                    next_state = STATE_STOP;
            end
            
            STATE_STOP: begin
                // !!! FILL IN CONDITION !!!
                // After the stop bit duration (434 cycles) finishes, where should the FSM go?
                if (clk_count == CLK_PER_BIT - 1)
                    next_state = STATE_IDLE /* Where to next? */;
            end
        endcase
    end

    // 3. Sequential Counters & Output Control Paths
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_count   <= 0;
            bit_index   <= 0;
            tx_data_reg <= 0;
            tx          <= 1'b1; // Idle line sits high
            tx_done     <= 1'b0;
        end else begin
            case (current_state)
                STATE_IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;
                    tx        <= 1'b1; // Drive high
                    tx_done   <= 1'b0;
                    if (tx_start) begin
                        tx_data_reg <= tx_data; // Sample input data stable
                    end
                end
                
                STATE_START: begin
                    tx <= 1'b0; // Drive Start Bit LOW
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 0; // Reset for next state
                    end
                end
                
                STATE_DATA: begin
                    
                    // Drive the tx output pin with the current bit of our data stream array.
                    tx <= tx_data_reg[bit_index]; 
                    
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1'b1;
                        end else begin
                            bit_index <= 0;
                        end
                    end
                end
                
                STATE_STOP: begin
                    tx <= 1'b1; // Drive Stop Bit HIGH
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 0;
                        tx_done   <= 1'b1; // Signal completion pulse
                    end
                end
            endcase
        end
    end

endmodule
