`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 05:05:06 PM
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
    reg [31:0] freq;       // Frequency control (updated to 32-bit bus)
    reg [1:0] wav_sel;     // Waveform selection
    reg voice_active;      // Voice active signal
    wire [7:0] wav_out;    // Output of waveform generator

    // Instantiate the waveform selector module
    wav_selector uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_sel(wav_sel),
        .voice_active(voice_active),
        .wav_out(wav_out)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        freq = 32'd440;          // Set initial frequency (A4, 440 Hz)
        wav_sel = 2'b00;         // Start with saw wave
        voice_active = 0;        // Default voice active is low

        // Start simulation
        $display("=== Starting Waveform Selector Testbench ===");

        // Reset the system
        #100;
        reset = 0;
        voice_active = 1; // Enable waveform generation
        $display("Time=%0t Reset Released", $time);

        // Test sawtooth wave output
        #200;
        wav_sel = 2'b00;
        $display("Time=%0t Testing Sawtooth Wave Output", $time);
        #5000000;

        // Test square wave output
        wav_sel = 2'b01;
        $display("Time=%0t Testing Square Wave Output", $time);
        #5000000;

        // Test triangle wave output
        wav_sel = 2'b10;
        $display("Time=%0t Testing Triangle Wave Output", $time);
        #5000000;

        // Test sine wave output
        wav_sel = 2'b11;
        $display("Time=%0t Testing Sine Wave Output", $time);
        #5000000;

        // End simulation
        voice_active = 0; // Disable waveform generation
        $display("=== Ending Waveform Selector Testbench ===");
        $finish;
    end

    // Debugging waveform output
    always @(posedge clk) begin
        $display("Time=%0t, wav_sel=%b, wav_out=%h", $time, wav_sel, wav_out);
    end

endmodule


