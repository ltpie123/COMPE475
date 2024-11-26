`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/23/2024 09:30:52 PM
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
    reg [6:0] midi_note;
    reg note_on;
    reg note_valid;
    reg [1:0] wav_sel;
    reg [15:0] attack_time;
    reg [15:0] decay_time;
    reg [7:0] sustain_level;
    reg [15:0] release_time;
    wire [7:0] wav_out;

    synth uut (
        .clk(clk),
        .reset(reset),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid),
        .wav_sel(wav_sel),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .wav_out(wav_out)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 100MHz clock (10ns period)
    end

    initial begin
        // Initialize all inputs
        reset = 1;
        note_on = 0;
        note_valid = 0;
        attack_time = 16'd100;
        decay_time = 16'd200;
        sustain_level = 8'd128;
        release_time = 16'd300;

        #100  // Longer reset period

        reset = 0;

        // Test Saw Wave (wav_sel = 00)
        wav_sel = 2'b00;
        midi_note = 7'd60;  // Middle C
        note_on = 1;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;  // Hold for 20us

        midi_note = 7'd72;  // C5
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        midi_note = 7'd48;  // C3
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        // Release previous note
        note_on = 0;
        note_valid = 1;
        #20
        note_valid = 0;
        #1000;

        // Test Square Wave (wav_sel = 01)
        wav_sel = 2'b01;
        midi_note = 7'd60;
        note_on = 1;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        midi_note = 7'd72;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        midi_note = 7'd48;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        // Release previous note
        note_on = 0;
        note_valid = 1;
        #20
        note_valid = 0;
        #1000;

        // Test Triangle Wave (wav_sel = 10)
        wav_sel = 2'b10;
        midi_note = 7'd60;
        note_on = 1;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        midi_note = 7'd72;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        midi_note = 7'd48;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        // Release previous note
        note_on = 0;
        note_valid = 1;
        #20
        note_valid = 0;
        #1000;

        // Test Sine Wave (wav_sel = 11)
        wav_sel = 2'b11;
        midi_note = 7'd60;
        note_on = 1;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        midi_note = 7'd72;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        midi_note = 7'd48;
        note_valid = 1;
        #20
        note_valid = 0;
        #20000;

        // Final release
        note_on = 0;
        note_valid = 1;
        #20
        note_valid = 0;
        #1000;

        // Test complete
        reset = 1;
        #100;
        $finish;
    end

    // Add waveform dumping for visualization
    initial begin
        $dumpfile("synth_tb.vcd");
        $dumpvars(0, synth_tb);
    end

endmodule