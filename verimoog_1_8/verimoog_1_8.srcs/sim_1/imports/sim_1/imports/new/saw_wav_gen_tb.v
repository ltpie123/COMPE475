`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/26/2024 07:36:44 PM
// Design Name:
// Module Name: sqr_wav_gen
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
        
        // Release reset after 100ns
        #100;
        reset = 0;
        #100;

        // Test with much larger frequency differences
        
        // Test Low Frequency (100 Hz)
        $display("Testing 100 Hz...");
        freq = 32'd100;
        #100000;

        // Test Medium-Low Frequency (500 Hz)
        $display("Testing 500 Hz...");
        freq = 32'd500;
        #100000;

        // Test Medium Frequency (1 kHz)
        $display("Testing 1 kHz...");
        freq = 32'd1000;
        #100000;

        // Test Medium-High Frequency (2 kHz)
        $display("Testing 2 kHz...");
        freq = 32'd2000;
        #100000;

        // Test High Frequency (4 kHz)
        $display("Testing 4 kHz...");
        freq = 32'd4000;
        #100000;

        // Test reset during operation
        $display("Testing reset behavior...");
        reset = 1;
        #100;
        reset = 0;
        freq = 32'd1000; // Back to 1 kHz
        #100000;

        $display("Simulation complete");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t freq=%0d wav_out=%h", $time, freq, wav_out);
    end

endmodule