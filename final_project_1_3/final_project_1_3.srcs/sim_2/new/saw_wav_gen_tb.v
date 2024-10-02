`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2024
// Design Name: 
// Module Name: saw_wav_gen_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Testbench for the sawtooth waveform generator
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module saw_wav_gen_tb;

    reg clk;
    reg reset;
    reg [31:0] freq;
    wire [7:0] wav_out;
    wire [31:0] counter_debug;
    wire [31:0] period_debug;

    // Instantiate the sawtooth wave generator
    saw_wav_gen uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(wav_out),
        .counter_debug(counter_debug),
        .period_debug(period_debug)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock
    end

    // Test sequence
    initial begin
        reset = 1; // Apply reset
        #20 reset = 0; // Release reset

        // Set frequency and monitor outputs
        freq = 7999; // Set frequency to 7,989 Hz
        #2000; // Wait 2ms
        freq = 5000; // Change frequency to 5,000 Hz
        #2000; // Wait 2ms
        freq = 2000; // Change frequency to 2,000 Hz
        #2000; // Wait 2ms
        freq = 1000; // Change frequency to 1,000 Hz
        #2000; // Wait 2ms
        freq = 500; // Change frequency to 500 Hz
        #2000; // Wait 2ms

        // Finish simulation
        $stop;
    end
endmodule

