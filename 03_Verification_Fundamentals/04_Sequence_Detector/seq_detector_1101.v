`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2026 05:54:16
// Design Name: 
// Module Name: seq_detector_1101
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

module seq_detector_1101 (
    input wire clk,
    input wire rst_n,
    input wire din,      // Serial Input stream
    output reg dout      // Goes high when 1101 is detected
);

    // 1. One-Hot State Encoding
    localparam IDLE       = 5'b00001;
    localparam STATE_1     = 5'b00010;
    localparam STATE_11    = 5'b00100;
    localparam STATE_110   = 5'b01000;
    localparam STATE_1101  = 5'b10000;

    reg [4:0] current_state, next_state;

    // 2. Sequential State Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // 3. Combinational Next State Logic (YOUR TURN!)
    always @(*) begin
        next_state = current_state; // Default value
        
        case (current_state)
            IDLE: begin
                if (din == 1'b1) next_state = STATE_1;
                else             next_state = IDLE;
            end
            
            STATE_1: begin
                if (din == 1'b1) next_state = STATE_11;
                else             next_state = IDLE;
            end
            
            STATE_11: begin
               // If din is '1', we stay at STATE_11 (because the last two bits are still 1-1).
                if (din == 1'b0) next_state = STATE_110;
                else              next_state = STATE_11;
            end
            
            STATE_110: begin
                // If din is '0', the sequence is completely broken. Send it back to IDLE.
                if (din == 1'b1) next_state = STATE_1101;
                else if (din == 1'b0) next_state = IDLE;
                else next_state = STATE_110;
            end
            
            STATE_1101: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // 4. Moore Output Assignment
    always @(*) begin
        if (current_state == STATE_1101)
            dout = 1'b1;
        else
            dout = 1'b0;
    end

endmodule
