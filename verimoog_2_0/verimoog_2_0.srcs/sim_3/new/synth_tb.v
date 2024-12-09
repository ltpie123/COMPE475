`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 03:43:25 PM
// Design Name: 
// Module Name: synth_tb
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

module synth_tb;

    reg clk;
    reg reset;
    reg [6:0] midi_note;            // MIDI note input
    reg note_on;                    // Updated to match 'note_on' signal in the synth module
    reg [1:0] wav_sel;              // Waveform selector input
    reg [7:0] attack_time;          // ADSR attack time
    reg [7:0] decay_time;           // ADSR decay time
    reg [7:0] sustain_level;        // ADSR sustain level
    reg [7:0] release_time;         // ADSR release time
    wire [7:0] wav_out;             // Synth output

    // Instantiate the Synth module
    synth uut (
        .clk(clk),
        .reset(reset),
        .midi_note(midi_note),
        .note_on(note_on),
        .wav_sel(wav_sel),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .wav_out(wav_out)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        midi_note = 7'd69;       // A4 (440 Hz)
        note_on = 0;
        wav_sel = 2'd0;          // Select first waveform
        attack_time = 8'd10;
        decay_time = 8'd20;
        sustain_level = 8'd80;
        release_time = 8'd30;

        $display("=== Starting Synth Testbench ===");

        // Reset the system
        #100;
        reset = 0;
        $display("Time=%0t Reset Released", $time);

        // Trigger a note
        note_on = 1;
        #50;
        note_on = 0;
        $display("Time=%0t Note Triggered", $time);

        // Simulate note playing for some time
        #1000000;

        // Change MIDI note
        midi_note = 7'd72; // C5 (523.25 Hz)
        note_on = 1;
        #50;
        note_on = 0;
        $display("Time=%0t Note Changed to C5", $time);

        // Simulate note playing for some time
        #1000000;

        // Change waveform
        wav_sel = 2'd1;          // Select second waveform
        note_on = 1;
        #50;
        note_on = 0;
        $display("Time=%0t Waveform Changed", $time);

        // Simulate note playing for some time
        #1000000;

        // Modify ADSR parameters
        attack_time = 8'd5;
        decay_time = 8'd15;
        sustain_level = 8'd60;
        release_time = 8'd10;
        note_on = 1;
        #50;
        note_on = 0;
        $display("Time=%0t ADSR Parameters Modified", $time);

        // Simulate note playing for some time
        #1000000;

        // End simulation
        $display("=== Ending Synth Testbench ===");
        $finish;
    end

    // Debugging output
    always @(posedge clk) begin
        $display("Time=%0t, midi_note=%d, wav_out=%h", $time, midi_note, wav_out);
    end

endmodule
