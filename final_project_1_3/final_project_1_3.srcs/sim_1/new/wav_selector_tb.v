`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 11:55:55 PM
// Design Name: 
// Module Name: wav_selector_tb
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

module wav_selector_tb;

    reg clk;
    reg reset;
    reg [1:0] wav_sel;
    reg [31:0] freq;
    wire [7:0] wav_out;

    // Instantiate the Unit Under Test (UUT)
    wav_selector uut (
        .clk(clk),
        .wav_sel(wav_sel),
        .freq(freq),
        .wav_out(wav_out)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (period = 10 ns)

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;       // Reset signal is high initially
        wav_sel = 2'b00; // Start with square wave selection
        freq = 32'd440; // Example frequency (5000 Hz)

        // Apply reset
        #10 reset = 0;   // Release reset after 10 ns

        // Test case 1: Select square wave
        #20 wav_sel = 2'b00; 
        #100; // Wait for a few cycles to observe square wave output

        // Test case 2: Select sine wave
        #20 wav_sel = 2'b01;
        #100; // Wait for a few cycles to observe sine wave output

        // Test case 3: Select sawtooth wave
        #20 wav_sel = 2'b10;
        #100; // Wait for a few cycles to observe sawtooth wave output

        // Test case 4: Select triangle wave
        #20 wav_sel = 2'b11;
        #100; // Wait for a few cycles to observe triangle wave output

        // Test case 5: Test invalid selection
        #20 wav_sel = 2'bxx; // Invalid case to observe the default behavior
        #100;

        // End simulation
        $stop;
    end
endmodule
