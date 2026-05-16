//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2026 04:52:19
// Design Name: 
// Module Name: full_adder_tb
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

module full_adder_tb;

    // 1. Declare signals to connect to the module
    reg  a, b, cin;
    wire s, cout;

    // 2. Instantiate the Unit Under Test (UUT)
    full_adder uut (
        .a(a), 
        .b(b), 
        .cin(cin), 
        .s(s), 
        .cout(cout)
    );

    // 3. Stimulus block
    initial begin
        // Display header for the console output
        $display("Time\t a b cin | s cout");
        $display("--------------------------");
        
        // Monitor will automatically print whenever a signal changes
        $monitor("%0t\t %b %b  %b  | %b   %b", $time, a, b, cin, s, cout);

        // Exhaustive testing of all 8 combinations
        {a, b, cin} = 3'b000; #10;
        {a, b, cin} = 3'b001; #10;
        {a, b, cin} = 3'b010; #10;
        {a, b, cin} = 3'b011; #10;
        {a, b, cin} = 1'b100; #10;
        {a, b, cin} = 3'b101; #10;
        {a, b, cin} = 3'b110; #10;
        {a, b, cin} = 3'b111; #10;

        $finish; // End the simulation
    end

endmodule
