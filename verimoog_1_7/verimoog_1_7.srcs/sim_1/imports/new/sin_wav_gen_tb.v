`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 11:46:18 AM
// Design Name: 
// Module Name: sin_wav_gen_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Testbench for sine wave generator.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sin_wav_gen_tb;
    // Test bench signals
    reg clk;
    reg reset;
    reg [31:0] freq;
    wire [7:0] wav_out;

    // Instantiate sine wave generator
    sin_wav_gen uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(wav_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize waveform dumps
        $dumpfile("sin_wav_gen_tb.vcd");
        $dumpvars(0, sin_wav_gen_tb);
        
        // Initialize signals
        reset = 1;
        freq = 0;
        
        // Release reset
        #100;
        reset = 0;
        #100;

        // Test different frequencies
        // Test A4 (440 Hz)
        $display("Testing A4 (440 Hz)...");
        freq = 32'd440;
        #10000;

        // Test A3 (220 Hz)
        $display("Testing A3 (220 Hz)...");
        freq = 32'd220;
        #10000;

        // Test A5 (880 Hz)
        $display("Testing A5 (880 Hz)...");
        freq = 32'd880;
        #10000;

        // Test reset during operation
        $display("Testing reset behavior...");
        reset = 1;
        #100;
        reset = 0;
        #100;

        // Test very low frequency
        $display("Testing low frequency (110 Hz)...");
        freq = 32'd110;
        #10000;

        $display("Simulation complete");
        $finish;
    end

    // Monitor output for analysis
    initial begin
        $monitor("Time=%0t freq=%0d wav_out=%h", $time, freq, wav_out);
    end

endmodule