`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 01:21:09 AM
// Design Name: 
// Module Name: processor_synth_tb
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

module processor_synth_tb();
    // Test bench signals
    reg clk;
    reg reset;
    reg midi_rx;
    wire pwm_audio_out;

    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .midi_rx(midi_rx),
        .pwm_audio_out(pwm_audio_out)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        midi_rx = 0;
        reset = 1;
        
        // Display test start
        $display("Starting processor synthesizer test");
        $display("Time\tReset\tMIDI_RX\tPWM_Out");
        $monitor("%0t\t%b\t%b\t%b", $time, reset, midi_rx, pwm_audio_out);

        // Hold reset for 100ns
        #100;
        reset = 0;
        $display("Reset released at time %0t", $time);

        // Let processor run for a while
        #1000;
        $display("Checking processor signals at time %0t", $time);
        
        // Check processor outputs
        $display("Current synth settings:");
        $display("Waveform = %h", uut.synth_if_inst.wav_sel);
        $display("Attack = %h", uut.synth_if_inst.attack_time);
        $display("Decay = %h", uut.synth_if_inst.decay_time);
        $display("Sustain = %h", uut.synth_if_inst.sustain_level);
        $display("Release = %h", uut.synth_if_inst.release_time);

        // Test MIDI input
        #100;
        midi_rx = 1;
        #100;
        midi_rx = 0;
        
        // Run for a while longer
        #1000;
        
        // End simulation
        $display("Test completed at time %0t", $time);
        $finish;
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("processor_synth.vcd");
        $dumpvars(0, processor_synth_tb);
    end

endmodule