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
    input wire [6:0] midi_note,
    input wire note_on,
    input wire note_valid,
    output reg [NUM_VOICES-1:0] voice_active,
    output reg [(NUM_VOICES*7)-1:0] voice_notes,
    output reg [NUM_VOICES-1:0] voice_trigger,
    output reg [3:0] active_voice_count
);

    // All declarations at module level
    reg [(NUM_VOICES*7)-1:0] voice_allocation;
    reg [(NUM_VOICES*8)-1:0] voice_age;
    integer i;
    reg [3:0] allocated_voice;
    reg found_free;
    reg [7:0] max_age;
    reg [7:0] current_age;
    reg [3:0] voice_index;

    // Helper functions
    function [7:0] get_age;
        input [(NUM_VOICES*8)-1:0] ages;
        input integer index;
        begin
            get_age = ages[index*8 +: 8];
        end
    endfunction

    function [(NUM_VOICES*8)-1:0] set_age;
        input [(NUM_VOICES*8)-1:0] ages;
        input integer index;
        input [7:0] value;
        begin
            set_age = ages;
            set_age[index*8 +: 8] = value;
        end
    endfunction

    function [3:0] find_oldest_voice;
        input [NUM_VOICES-1:0] active_voices;
        input [(NUM_VOICES*8)-1:0] ages;
        begin
            max_age = 0;
            voice_index = 0;
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                current_age = get_age(ages, i);
                if (active_voices[i] && current_age > max_age) begin
                    max_age = current_age;
                    voice_index = i;
                end
            end
            find_oldest_voice = voice_index;
        end
    endfunction

    function [3:0] allocate_voice;
        input [NUM_VOICES-1:0] active_voices;
        input [(NUM_VOICES*8)-1:0] ages;
        begin
            found_free = 0;
            voice_index = 0;

            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                if (!active_voices[i] && !found_free) begin
                    found_free = 1;
                    voice_index = i;
                end
            end

            if (!found_free) begin
                voice_index = find_oldest_voice(active_voices, ages);
            end

            allocate_voice = voice_index;
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voice_active <= 0;
            voice_trigger <= 0;
            active_voice_count <= 0;
            voice_notes <= 0;
            voice_allocation <= 0;
            voice_age <= 0;
        end
        else begin
            voice_trigger <= 0;

            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                if (voice_active[i])
                    voice_age[i*8 +: 8] <= voice_age[i*8 +: 8] + 1;
            end

            if (note_valid) begin
                if (note_on) begin
                    allocated_voice = allocate_voice(voice_active, voice_age);
                    voice_active[allocated_voice] <= 1;
                    voice_notes[allocated_voice*7 +: 7] <= midi_note;
                    voice_allocation[allocated_voice*7 +: 7] <= midi_note;
                    voice_age[allocated_voice*8 +: 8] <= 0;
                    voice_trigger[allocated_voice] <= 1;
                    active_voice_count <= active_voice_count + !voice_active[allocated_voice];
                end
                else begin
                    for (i = 0; i < NUM_VOICES; i = i + 1) begin
                        if (voice_active[i] && voice_allocation[i*7 +: 7] == midi_note) begin
                            voice_active[i] <= 0;
                            voice_age[i*8 +: 8] <= 0;
                            active_voice_count <= active_voice_count - 1;
                        end
                    end
                end
            end
        end
    end

endmodule