`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024 11:46:18 AM
// Design Name:
// Module Name: saw_wav_gen_tb
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

module saw_wav_gen_tb;
    // Test bench signals
    reg clk;
    reg reset;
    reg [31:0] freq;
    wire [7:0] wav_out;

    // Instantiate sawtooth wave generator
    saw_wav_gen uut (
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
        $dumpfile("saw_wav_gen_tb.vcd");
        $dumpvars(0, saw_wav_gen_tb);

        // Initialize signals
        reset = 1;
        freq = 0;

        // Release reset
        #100;
        reset = 0;
        #100;

        // Test different frequencies
        // Test Middle C (261.63 Hz)
        $display("Testing Middle C (261.63 Hz)...");
        freq = 32'd262;
        #10000;

        // Test A4 (440 Hz)
        $display("Testing A4 (440 Hz)...");
        freq = 32'd440;
        #10000;

        // Test E4 (329.63 Hz)
        $display("Testing E4 (329.63 Hz)...");
        freq = 32'd330;
        #10000;

        // Test reset during operation
        $display("Testing reset behavior...");
        reset = 1;
        #100;
        reset = 0;
        #100;

        // Test frequency change during operation
        $display("Testing frequency change...");
        freq = 32'd523; // C5
        #10000;

        $display("Simulation complete");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t freq=%0d wav_out=%h", $time, freq, wav_out);
    end

endmodule
