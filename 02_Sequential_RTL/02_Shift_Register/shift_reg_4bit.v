`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2026 05:15:31
// Design Name: 
// Module Name: shift_reg_4bit
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


module shift_reg_4bit(
  input clk,rst_n,d,
  output reg q_out
);
   reg[3:0]q_reg;
  always@(posedge clk or negedge rst_n)begin
   if(!rst_n)begin
     q_reg<=4'b0000;
   end else begin
     q_reg[0]<=d;
     q_reg[1]<=q_reg[0];
     q_reg[2]<=q_reg[1];
     q_reg[3]<=q_reg[2];
   end
  end
  always@(*)begin
   q_out=q_reg[3];
  end
endmodule
