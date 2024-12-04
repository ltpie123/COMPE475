`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 08:31:39 PM
// Design Name: 
// Module Name: midi_to_freq_tb
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



module midi_to_freq_tb;
    // Test bench signals
    reg [6:0] midi_in;
    wire [31:0] freq_out;

    // Instantiate MIDI to frequency converter
    midi_to_freq uut (
        .midi_in(midi_in),
        .freq_out(freq_out)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumps
        $dumpfile("midi_to_freq_tb.vcd");
        $dumpvars(0, midi_to_freq_tb);

        // Test various MIDI notes
        // Test middle C (C4)
        $display("Testing Middle C (C4)...");
        midi_in = 7'd60;
        #100;

        // Test A4 (concert pitch)
        $display("Testing A4 (concert pitch)...");
        midi_in = 7'd69;
        #100;

        // Test C3 (one octave below middle C)
        $display("Testing C3...");
        midi_in = 7'd48;
        #100;

        // Test C5 (one octave above middle C)
        $display("Testing C5...");
        midi_in = 7'd72;
        #100;

        // Test low note
        $display("Testing low note...");
        midi_in = 7'd50;
        #100;

        // Test high note
        $display("Testing high note...");
        midi_in = 7'd80;
        #100;

        // Test invalid note (should output 0)
        $display("Testing invalid note...");
        midi_in = 7'd127;
        #100;

        $display("Simulation complete");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t midi_in=%d freq_out=%d Hz", 
                 $time, midi_in, freq_out);
    end

endmodule