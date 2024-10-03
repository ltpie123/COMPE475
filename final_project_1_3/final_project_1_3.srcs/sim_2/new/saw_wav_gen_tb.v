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

    // Instantiate the sawtooth wave generator
    saw_wav_gen uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(wav_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test sequence
    initial begin
        reset = 1; // Apply reset
        #20 reset = 0; // Release reset

        // Set frequency and monitor outputs
        freq = 32'd131; // Set frequency to C3
        #4000; // Wait 2ms
        freq = 32'd262; // Change frequency to C4
        #4000; // Wait 2ms
        freq = 32'd523; // Change frequency to C5
        #4000; // Wait 2ms
        freq = 32'd1047; // Change frequency to C6
        #4000; // Wait 2ms
        freq = 32'd440; // Change frequency to A4
        #4000; // Wait 2ms

        // Finish simulation
        $stop;
    end
endmodule

