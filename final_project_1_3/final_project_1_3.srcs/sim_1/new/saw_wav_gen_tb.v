`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024
// Design Name: 
// Module Name: saw_wav_gen_tb
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

    // Parameters
    reg clk;
    reg reset;
    reg [31:0] freq;
    wire [7:0] wav_out;

    // Instantiate the Unit Under Test (UUT)
    saw_wav_gen uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(wav_out)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test Procedure
    initial begin
        // Initialize Inputs
        reset = 1;              // Assert reset
        freq = 32'd440;         // Frequency of A4 (440 Hz)
        
        // Wait for some time and then release reset
        #10;
        reset = 0;              // De-assert reset

        // Simulate for 1 second with frequency changes
        #1000000; // Simulate for 1 second

        // Change frequency to E4 (329.63 Hz)
        freq = 32'd330;         // Frequency of E4
        #1000000; // Simulate for another 1 second
        
        // Change frequency to C5 (523.25 Hz)
        freq = 32'd523;         // Frequency of C5
        #1000000; // Simulate for another 1 second
        
        // Assert reset again
        reset = 1;              // Assert reset
        #10;                    
        reset = 0;              // De-assert reset
        freq = 32'd262;         // Frequency of C4 (261.63 Hz)
        #1000000; // Simulate for another 1 second

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %t | wav_out: %d | freq: %d | reset: %b", $time, wav_out, freq, reset);
    end

endmodule
