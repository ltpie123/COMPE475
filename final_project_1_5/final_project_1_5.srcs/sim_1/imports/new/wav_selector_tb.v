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

`timescale 1ns / 1ps

module wav_selector_tb;
    reg clk;
    reg reset;
    reg [1:0] wav_sel;
    reg [31:0] freq;
    reg voice_active;
    reg voice_trigger;
    wire [7:0] wav_out;

    // Instantiate the Unit Under Test (UUT)
    wav_selector uut (
        .clk(clk),
        .reset(reset),
        .wav_sel(wav_sel),
        .freq(freq),
        .voice_active(voice_active),
        .voice_trigger(voice_trigger),
        .wav_out(wav_out)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (period = 10 ns)

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        wav_sel = 2'b00;
        freq = 32'd5000;
        voice_active = 0;
        voice_trigger = 0;

        // Apply reset
        #1000 reset = 0;
        voice_active = 1;  // Enable voice after reset

        // Test case 1: Sawtooth wave (00)
        #20 wav_sel = 2'b00;
        #1000000;

        // Test case 2: Square wave (01)
        #20 wav_sel = 2'b01;
        #1000000;

        // Test case 3: Triangle wave (10)
        #20 wav_sel = 2'b10;
        #1000000;

        // Test case 4: Sine wave (11)
        #20 wav_sel = 2'b11;
        #1000000;

        // Test voice_active behavior
        #20 voice_active = 0;
        #1000000;

        // Re-enable and test different frequency
        #20 voice_active = 1;
        freq = 32'd10000; // Change to 10kHz
        #1000000;

        $stop;
    end

endmodule
