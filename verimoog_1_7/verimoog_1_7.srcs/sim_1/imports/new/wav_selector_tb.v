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
    // Test bench signals
    reg clk;
    reg reset;
    reg [1:0] wav_sel;
    reg [31:0] freq;
    reg voice_active;
    wire [7:0] wav_out;

    // Instantiate wave selector module
    wav_selector uut (
        .clk(clk),
        .reset(reset),
        .wav_sel(wav_sel),
        .freq(freq),
        .voice_active(voice_active),
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
        $dumpfile("wav_selector_tb.vcd");
        $dumpvars(0, wav_selector_tb);
        
        // Initialize signals
        reset = 1;
        wav_sel = 2'b00;
        freq = 32'd440; // A4 note
        voice_active = 0;
        
        // Release reset
        #100;
        reset = 0;
        #100;

        // Test each waveform type with voice active
        voice_active = 1;
        
        // Test sawtooth wave (00)
        $display("Testing sawtooth wave...");
        wav_sel = 2'b00;
        #10000000; // 10 ms
        
        // Test square wave (01)
        $display("Testing square wave...");
        wav_sel = 2'b01;
        #10000000;
        
        // Test triangle wave (10)
        $display("Testing triangle wave...");
        wav_sel = 2'b10;
        #10000000;
        
        // Test sine wave (11)
        $display("Testing sine wave...");
        wav_sel = 2'b11;
        #10000000;

        // Test voice inactive behavior
        $display("Testing voice inactive behavior...");
        voice_active = 0;
        #5000000; // 5 ms
        
        // Test frequency change
        $display("Testing frequency change...");
        voice_active = 1;
        freq = 32'd880; // A5 note
        #10000000;

        // Test reset behavior
        $display("Testing reset behavior...");
        reset = 1;
        #100;
        reset = 0;
        #100;

        $display("Simulation complete");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t wav_sel=%b voice_active=%b wav_out=%h", 
                 $time, wav_sel, voice_active, wav_out);
    end
endmodule