`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2026 05:58:34
// Design Name: 
// Module Name: system_ctrl
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

module system_ctrl (
    input wire clk,
    input wire rst_n,
    input wire [1:0] cmd, // 00 = Stay/Idle, 01 = Go to Read, 10 = Go to Write
    output reg read_en,
    output reg write_en
);

    // 1. State Encoding using Local Parameters (One-Hot Style)
    localparam IDLE  = 3'b001;
    localparam READ  = 3'b010;
    localparam WRITE = 3'b100;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // 2. Sequential State Register (Reset & State Update)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // 3. Combinational Next State Logic (YOUR TURN TO WRITE THIS!)
    always @(*) begin
        // Default assignment to avoid latch inference
        next_state = current_state; 
        
        case (current_state)
            IDLE: begin
                if (cmd == 2'b01)       next_state = READ;
                else if (cmd == 2'b10)  next_state = WRITE;
                else                    next_state = IDLE;
            end
            
            READ: begin
                // !!! YOUR TURN !!!
                // If cmd == 2'b00, go back to IDLE. Otherwise, stay in READ.
                // Write the code line below:
                if (cmd == 2'b00)       next_state = IDLE;
                else if (cmd == 2'b10)  next_state = WRITE;
                else                    next_state = READ;
            end
            
            WRITE: begin
                // !!! YOUR TURN !!!
                // If cmd == 2'b00, go back to IDLE. Otherwise, stay in WRITE.
                // Write the code line below:
                if (cmd == 2'b00)       next_state = IDLE;
                else if (cmd == 2'b01)  next_state = READ;
                else                    next_state = WRITE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // 4. Moore Output Logic (Outputs depend ONLY on current_state)
    always @(*) begin
        read_en  = 1'b0;
        write_en = 1'b0;
        
        case (current_state)
            IDLE:  begin read_en = 1'b0; write_en = 1'b0; end
            READ:  begin read_en = 1'b1; write_en = 1'b0; end
            WRITE: begin read_en = 1'b0; write_en = 1'b1; end
            default: begin read_en = 1'b0; write_en = 1'b0; end
        endcase
    end

endmodule
