`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 12:31:24 AM
// Design Name: 
// Module Name: processor_synth_interface
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

module processor_synth_interface(
    input wire clk,
    input wire rst,
    // Processor interface - all 8-bit
    input wire [7:0] proc_addr,
    input wire proc_write,
    input wire proc_read,
    input wire [7:0] proc_data_out,
    output reg [7:0] proc_data_in,
    // Synthesizer interface - converted to 8-bit
    input wire [6:0] midi_note,
    input wire note_on,
    input wire note_valid,
    output reg [1:0] wav_sel,
    output reg [7:0] attack_time,    // Changed from 16-bit
    output reg [7:0] decay_time,     // Changed from 16-bit
    output reg [7:0] sustain_level,  // Already 8-bit
    output reg [7:0] release_time,   // Changed from 16-bit
    // Synchronization signals
    output reg midi_valid_sync,
    output reg [6:0] midi_note_sync,
    output reg note_on_sync
);

    // Memory-mapped register addresses
    localparam ADDR_WAV_SEL = 8'h00;      // Waveform selection
    localparam ADDR_ATTACK = 8'h01;       // Attack time
    localparam ADDR_DECAY = 8'h02;        // Decay time  
    localparam ADDR_SUSTAIN = 8'h03;      // Sustain level
    localparam ADDR_RELEASE = 8'h04;      // Release time
    localparam ADDR_MIDI_NOTE = 8'h05;    // Current MIDI note
    localparam ADDR_NOTE_STATUS = 8'h06;  // Note on/valid status

    // Synchronization registers
    reg midi_valid_meta, note_on_meta;
    reg [6:0] midi_note_meta;

    // Two-stage synchronizer 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            midi_valid_meta <= 0;
            midi_valid_sync <= 0;
            note_on_meta <= 0;
            note_on_sync <= 0;
            midi_note_meta <= 0;
            midi_note_sync <= 0;
        end else begin
            // First stage
            midi_valid_meta <= note_valid;
            note_on_meta <= note_on;
            midi_note_meta <= midi_note;
            
            // Second stage
            midi_valid_sync <= midi_valid_meta;
            note_on_sync <= note_on_meta;
            midi_note_sync <= midi_note_meta;
        end
    end

    // Register writes - simplified for 8-bit
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wav_sel <= 2'b00;
            attack_time <= 8'h00;
            decay_time <= 8'h00;
            sustain_level <= 8'h00;
            release_time <= 8'h00;
        end else if (proc_write) begin
            case (proc_addr)
                ADDR_WAV_SEL: wav_sel <= proc_data_out[1:0];
                ADDR_ATTACK: attack_time <= proc_data_out;
                ADDR_DECAY: decay_time <= proc_data_out;
                ADDR_SUSTAIN: sustain_level <= proc_data_out;
                ADDR_RELEASE: release_time <= proc_data_out;
            endcase
        end
    end

    // Register reads - simplified for 8-bit
    always @(*) begin
        case (proc_addr)
            ADDR_WAV_SEL: proc_data_in = {6'b0, wav_sel};
            ADDR_ATTACK: proc_data_in = attack_time;
            ADDR_DECAY: proc_data_in = decay_time;
            ADDR_SUSTAIN: proc_data_in = sustain_level;
            ADDR_RELEASE: proc_data_in = release_time;
            ADDR_MIDI_NOTE: proc_data_in = {1'b0, midi_note_sync};
            ADDR_NOTE_STATUS: proc_data_in = {6'b0, midi_valid_sync, note_on_sync};
            default: proc_data_in = 8'h00;
        endcase
    end

endmodule