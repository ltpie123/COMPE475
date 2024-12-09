`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 12:03:55 PM
// Design Name: 
// Module Name: top_tb
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

module top_tb;
    // Testbench signals
    reg clk;
    reg reset;
    reg midi_rx;
    wire pwm_audio_out;

    // Internal monitoring signals
    wire [15:0] instruction;
    wire [7:0] proc_data_out;
    wire [7:0] proc_data_in;
    wire [2:0] control_state;
    wire [6:0] midi_note;
    wire note_on;
    wire note_valid;
    wire [1:0] wav_sel;
    wire [7:0] attack_time;
    wire [7:0] decay_time;
    wire [7:0] sustain_level;
    wire [7:0] release_time;
    wire [7:0] synth_audio_out;

    // Clock period definitions
    parameter CLK_PERIOD = 10; // 100MHz clock
    parameter MIDI_BIT_PERIOD = 32000; // 31.25kHz MIDI rate

    // Instantiate top module
    top dut (
        .clk(clk),
        .reset(reset),
        .midi_rx(midi_rx),
        .pwm_audio_out(pwm_audio_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Connect debug signals
    assign instruction = dut.processor_inst.inst_mem.instruction;
    assign proc_data_out = dut.processor_inst.data_out;
    assign proc_data_in = dut.processor_inst.data_in;
    assign control_state = dut.processor_inst.control_unit_i.state;
    assign midi_note = dut.midi_input_inst.midi_note;
    assign note_on = dut.midi_input_inst.note_on;
    assign note_valid = dut.midi_input_inst.note_valid;
    assign wav_sel = dut.interface_inst.wav_sel;
    assign attack_time = dut.interface_inst.attack_time;
    assign decay_time = dut.interface_inst.decay_time;
    assign sustain_level = dut.interface_inst.sustain_level;
    assign release_time = dut.interface_inst.release_time;
    assign synth_audio_out = dut.synth_inst.wav_out;

    // Test stimulus
    initial begin
        // Initialize
        $display("=== Starting Testbench ===");
        reset = 1;
        midi_rx = 1;

        // Wait for 10 clock cycles with reset
        repeat(10) @(posedge clk);

        // Release reset
        reset = 0;
        @(posedge clk);
        $display("Reset released at time %0t", $time);

        // Wait for processor initialization
        repeat(5) @(posedge clk);

        // Test sequence 1: MIDI Note On
        $display("\n=== Testing MIDI Note On Sequence ===");
        send_midi_byte(8'h90); // Note On status
        send_midi_byte(8'h3C); // Note number (60 - middle C)
        send_midi_byte(8'h40); // Velocity (64)

        // Wait for processing
        repeat(100) @(posedge clk);

        // Test sequence 2: MIDI Note Off
        $display("\n=== Testing MIDI Note Off Sequence ===");
        send_midi_byte(8'h80); // Note Off status
        send_midi_byte(8'h3C); // Note number (60)
        send_midi_byte(8'h00); // Velocity

        // Wait for processing
        repeat(100) @(posedge clk);

        // Test complete
        $display("\n=== Test Complete at time %0t ===", $time);
        repeat(10) @(posedge clk);
        $finish;
    end

    // Task to send MIDI byte
    task send_midi_byte;
        input [7:0] byte_to_send;
        integer i;
        begin
            // Start bit
            midi_rx = 0;
            #(MIDI_BIT_PERIOD);

            // Data bits LSB first
            for (i = 0; i < 8; i = i + 1) begin
                midi_rx = byte_to_send[i];
                #(MIDI_BIT_PERIOD);
            end

            // Stop bit
            midi_rx = 1;
            #(MIDI_BIT_PERIOD);

            $display("MIDI Byte Sent: %h at time %0t", byte_to_send, $time);
        end
    endtask

    // Monitor processor state, signals, and synthesizer output
    always @(posedge clk) begin
        // Monitor processor state
        if (control_state !== 3'bxxx) begin
            $display("Time=%0t Control State=%d", $time, control_state);
        end

        // Monitor instruction execution
        if (instruction !== 16'hxxxx) begin
            $display("Time=%0t Instruction=%h Data_Out=%h Data_In=%h",
                    $time, instruction, proc_data_out, proc_data_in);
        end

        // Monitor MIDI input
        if (midi_note !== 7'hxx || note_on !== 1'bx || note_valid !== 1'bx) begin
            $display("Time=%0t MIDI Note=%d Note_On=%b Note_Valid=%b",
                    $time, midi_note, note_on, note_valid);
        end

        // Monitor synthesizer control parameters
        if (wav_sel !== 2'bxx || attack_time !== 8'hxx || decay_time !== 8'hxx ||
            sustain_level !== 8'hxx || release_time !== 8'hxx) begin
            $display("Time=%0t Waveform=%b Attack=%d Decay=%d Sustain=%d Release=%d",
                    $time, wav_sel, attack_time, decay_time, sustain_level, release_time);
        end

        // Monitor synthesizer audio output
        if (synth_audio_out !== 8'hxx) begin
            $display("Time=%0t Audio Output=%h", $time, synth_audio_out);
        end
    end

endmodule