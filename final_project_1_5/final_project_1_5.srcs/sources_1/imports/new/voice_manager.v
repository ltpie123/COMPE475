`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024
// Design Name: Voice Manager
// Module Name: voice_manager
// Project Name: Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Manages multiple voices for polyphonic synthesis.
//    - Allocates voices to incoming MIDI notes
//    - Implements voice stealing when all voices are in use
//    - Tracks active notes and their corresponding voices
//
// Dependencies: None
//
// Parameters:
//    NUM_VOICES: Number of simultaneous voices supported (default: 8)
//
//////////////////////////////////////////////////////////////////////////////////

module voice_manager #(
    parameter NUM_VOICES = 8
)(
    input wire clk,
    input wire reset,

    // MIDI input interface
    input wire [6:0] midi_note,
    input wire note_on,
    input wire note_valid,

    // Voice allocation outputs
    output reg [NUM_VOICES-1:0] voice_active,
    output reg [6:0] voice_notes [0:NUM_VOICES-1],
    output reg [NUM_VOICES-1:0] voice_trigger, // Triggers envelope generators

    // Debug outputs
    output reg [3:0] active_voice_count
);

    // Voice tracking
    reg [6:0] voice_allocation [0:NUM_VOICES-1];  // Which note each voice is playing
    reg [7:0] voice_age [0:NUM_VOICES-1];        // Age counter for voice stealing

    integer i;

    // Find oldest voice for voice stealing
    function [3:0] find_oldest_voice;
        input [NUM_VOICES-1:0] active_voices;
        input [7:0] ages [0:NUM_VOICES-1];
        reg [7:0] max_age;
        reg [3:0] oldest_voice;
        begin
            max_age = 0;
            oldest_voice = 0;
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                if (active_voices[i] && ages[i] > max_age) begin
                    max_age = ages[i];
                    oldest_voice = i;
                end
            end
            find_oldest_voice = oldest_voice;
        end
    endfunction

    // Find free voice or steal one if needed
    function [3:0] allocate_voice;
        input [NUM_VOICES-1:0] active_voices;
        input [7:0] ages [0:NUM_VOICES-1];
        reg found_free;
        reg [3:0] voice_index;
        begin
            found_free = 0;
            voice_index = 0;

            // First try to find an inactive voice
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                if (!active_voices[i] && !found_free) begin
                    found_free = 1;
                    voice_index = i;
                end
            end

            // If no free voices, steal the oldest one
            if (!found_free) begin
                voice_index = find_oldest_voice(active_voices, ages);
            end

            allocate_voice = voice_index;
        end
    endfunction

    // Voice allocation and management
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voice_active <= 0;
            voice_trigger <= 0;
            active_voice_count <= 0;
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                voice_notes[i] <= 0;
                voice_allocation[i] <= 0;
                voice_age[i] <= 0;
            end
        end
        else begin
            // Clear trigger flags
            voice_trigger <= 0;

            // Increment age counters for active voices
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                if (voice_active[i])
                    voice_age[i] <= voice_age[i] + 1;
            end

            // Process new note events
            if (note_valid) begin
                if (note_on) begin
                    // Allocate a voice for the new note
                    reg [3:0] allocated_voice;
                    allocated_voice = allocate_voice(voice_active, voice_age);

                    // Activate the voice
                    voice_active[allocated_voice] <= 1;
                    voice_notes[allocated_voice] <= midi_note;
                    voice_allocation[allocated_voice] <= midi_note;
                    voice_age[allocated_voice] <= 0;
                    voice_trigger[allocated_voice] <= 1;

                    // Update active voice count
                    active_voice_count <= active_voice_count + !voice_active[allocated_voice];
                end
                else begin
                    // Find and deactivate voices playing this note
                    for (i = 0; i < NUM_VOICES; i = i + 1) begin
                        if (voice_active[i] && voice_allocation[i] == midi_note) begin
                            voice_active[i] <= 0;
                            voice_age[i] <= 0;
                            active_voice_count <= active_voice_count - 1;
                        end
                    end
                end
            end
        end
    end

endmodule
