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
    input wire clk,                    // System clock (100MHz)
    input wire reset,                  // Global reset
    input wire midi_rx,                // MIDI serial input
    input wire [1:0] wav_sel,          // Direct waveform override
    output wire pwm_audio_out,         // Final audio output
    
    // Debug/Monitor outputs
    output wire [7:0] processor_port_out,
    output wire proc_read_strobe,
    output wire proc_write_strobe
);

    // Internal control signals
    wire [7:0] proc_data_in;
    wire [7:0] proc_data_out;
    wire [7:0] proc_port_addr;
    wire proc_read_e;
    wire proc_write_e;

    // Synth control registers
    reg [2:0] attack_time_reg = 3'd2;    // Default moderate attack
    reg [2:0] decay_time_reg = 3'd3;     // Default moderate decay
    reg [3:0] sustain_level_reg = 4'd8;  // Default 50% sustain
    reg [2:0] release_time_reg = 3'd4;   // Default moderate release
    reg [1:0] waveform_reg = 2'b00;      // Default sawtooth
    
    // MIDI interface signals
    wire [6:0] midi_note;
    wire note_on;
    wire note_valid;
    wire [7:0] wav_out;

    // Port address definitions
    localparam ADDR_ATTACK = 8'h00;
    localparam ADDR_DECAY = 8'h01;
    localparam ADDR_SUSTAIN = 8'h02;
    localparam ADDR_RELEASE = 8'h03;
    localparam ADDR_WAVEFORM = 8'h04;
    localparam ADDR_MIDI_STATUS = 8'h05;
    localparam ADDR_MIDI_NOTE = 8'h06;
    
    // Instantiate the Natalius processor
    natalius_processor processor_inst(
        .clk(clk),
        .rst(reset),
        .port_addr(proc_port_addr),
        .read_e(proc_read_e),
        .write_e(proc_write_e),
        .data_in(proc_data_in),
        .data_out(proc_data_out)
    );
    
    // Memory-mapped I/O handling
    always @(posedge clk) begin
        if (reset) begin
            attack_time_reg <= 3'd2;
            decay_time_reg <= 3'd3;
            sustain_level_reg <= 4'd8;
            release_time_reg <= 3'd4;
            waveform_reg <= 2'b00;
        end
        else if (proc_write_e) begin
            case (proc_port_addr)
                ADDR_ATTACK: attack_time_reg <= proc_data_out[2:0];
                ADDR_DECAY: decay_time_reg <= proc_data_out[2:0];
                ADDR_SUSTAIN: sustain_level_reg <= proc_data_out[3:0];
                ADDR_RELEASE: release_time_reg <= proc_data_out[2:0];
                ADDR_WAVEFORM: waveform_reg <= proc_data_out[1:0];
            endcase
        end
    end
    
    // Processor read data multiplexer
    assign proc_data_in = 
        (proc_port_addr == ADDR_MIDI_STATUS) ? {7'b0, note_on} :
        (proc_port_addr == ADDR_MIDI_NOTE) ? {1'b0, midi_note} :
        8'h00;  // Default value for undefined addresses
        
    // Instantiate the synthesizer core with processor-controlled parameters
    synth synth_inst(
        .clk(clk),
        .reset(reset),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid),
        .wav_sel(wav_sel_final),
        .attack_time(attack_time_reg),
        .decay_time(decay_time_reg),
        .sustain_level(sustain_level_reg),
        .release_time(release_time_reg),
        .wav_out(wav_out)
    );
    
    // MIDI input processing
    midi_input midi_input_inst(
        .clk(clk),
        .reset(reset),
        .midi_rx(midi_rx),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid)
    );
    
    // PWM audio output stage
    pwm_audio pwm_audio_inst(
        .clk(clk),
        .reset(reset),
        .audio_in(wav_out),
        .pwm_out(pwm_audio_out)
    );
    
    // Allow external waveform selection to override processor
    wire [1:0] wav_sel_final = wav_sel != 2'b11 ? wav_sel : waveform_reg;
    
    // Debug/monitor outputs
    assign processor_port_out = proc_data_out;
    assign proc_read_strobe = proc_read_e;
    assign proc_write_strobe = proc_write_e;

endmodule