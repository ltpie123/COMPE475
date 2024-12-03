`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: 
//
// Create Date: 12/02/2024 08:41:39 PM
// Design Name: MIDI Input Testbench
// Module Name: midi_input_tb
// Project Name: Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//   Testbench for the MIDI input interface module.
//
// Dependencies: midi_input.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module midi_input_tb;
    // Test bench signals
    reg clk;
    reg reset;
    reg midi_rx;
    wire [6:0] midi_note;
    wire note_on;
    wire note_valid;

    // Instantiate the MIDI input module
    midi_input uut (
        .clk(clk),
        .reset(reset),
        .midi_rx(midi_rx),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // MIDI input stimulus
    initial begin
        // Initialize signals
        reset = 1;
        midi_rx = 1;

        // Release reset
        #100;
        reset = 0;
        #100;

        // Test Note On message
        $display("Testing Note On message...");
        @(posedge clk) midi_rx = 0; // Start bit
        #(3200) midi_rx = 1; // Bit 0 (Note On status byte)
        #(3200) midi_rx = 0; // Bit 1 (Note number)
        #(3200) midi_rx = 1; // Bit 2
        #(3200) midi_rx = 0; // Bit 3
        #(3200) midi_rx = 1; // Bit 4
        #(3200) midi_rx = 0; // Bit 5
        #(3200) midi_rx = 1; // Bit 6
        #(3200) midi_rx = 0; // Bit 7 (Note number)
        #(3200) midi_rx = 1; // Stop bit
        @(posedge note_valid) begin
            if (note_on != 1) begin
                $error("Note On signal not set");
            end
            if (midi_note != 7'd60) begin
                $error("Incorrect MIDI note number");
            end
        end

        // Test Note Off message
        $display("Testing Note Off message...");
        @(posedge clk) midi_rx = 0; // Start bit
        #(3200) midi_rx = 0; // Bit 0 (Note Off status byte)
        #(3200) midi_rx = 1; // Bit 1 (Note number)
        #(3200) midi_rx = 0; // Bit 2
        #(3200) midi_rx = 1; // Bit 3
        #(3200) midi_rx = 0; // Bit 4
        #(3200) midi_rx = 1; // Bit 5
        #(3200) midi_rx = 0; // Bit 6
        #(3200) midi_rx = 1; // Bit 7 (Note number)
        #(3200) midi_rx = 1; // Stop bit
        @(posedge note_valid) begin
            if (note_on != 0) begin
                $error("Note On signal not cleared");
            end
            if (midi_note != 7'd60) begin
                $error("Incorrect MIDI note number");
            end
        end

        // Test invalid MIDI message
        $display("Testing invalid MIDI message...");
        @(posedge clk) midi_rx = 0; // Start bit
        #(3200) midi_rx = 1; // Bit 0 (Invalid status byte)
        #(3200) midi_rx = 0; // Bit 1
        #(3200) midi_rx = 1; // Bit 2
        #(3200) midi_rx = 0; // Bit 3
        #(3200) midi_rx = 1; // Bit 4
        #(3200) midi_rx = 0; // Bit 5
        #(3200) midi_rx = 1; // Bit 6
        #(3200) midi_rx = 0; // Bit 7
        #(3200) midi_rx = 1; // Stop bit
        @(posedge note_valid) begin
            if (note_on != 0) begin
                $error("Note On signal set for invalid MIDI message");
            end
        end

        // Test multiple MIDI messages
        $display("Testing multiple MIDI messages...");
        @(posedge clk) midi_rx = 0; // Start bit
        #(3200) midi_rx = 1; // Bit 0 (Note On status byte)
        #(3200) midi_rx = 0; // Bit 1 (Note number)
        #(3200) midi_rx = 1; // Bit 2
        #(3200) midi_rx = 0; // Bit 3
        #(3200) midi_rx = 1; // Bit 4
        #(3200) midi_rx = 0; // Bit 5
        #(3200) midi_rx = 1; // Bit 6
        #(3200) midi_rx = 0; // Bit 7 (Note number)
        #(3200) midi_rx = 1; // Stop bit
        @(posedge note_valid) begin
            if (note_on != 1) begin
                $error("Note On signal not set");
            end
            if (midi_note != 7'd60) begin
                $error("Incorrect MIDI note number");
            end
        end

        @(posedge clk) midi_rx = 0; // Start bit
        #(3200) midi_rx = 0; // Bit 0 (Note Off status byte)
        #(3200) midi_rx = 1; // Bit 1 (Note number)
        #(3200) midi_rx = 0; // Bit 2
        #(3200) midi_rx = 1; // Bit 3
        #(3200) midi_rx = 0; // Bit 4
        #(3200) midi_rx = 1; // Bit 5
        #(3200) midi_rx = 0; // Bit 6
        #(3200) midi_rx = 1; // Bit 7 (Note number)
        #(3200) midi_rx = 1; // Stop bit
        @(posedge note_valid) begin
            if (note_on != 0) begin
                $error("Note On signal not cleared");
            end
            if (midi_note != 7'd60) begin
                $error("Incorrect MIDI note number");
            end
        end

        $display("Simulation complete");
        $finish;
    end

    // Monitor MIDI input and output signals
    initial begin
        $monitor("Time: %0t, MIDI Note: %d, Note On: %b, Note Valid: %b", $time, midi_note, note_on, note_valid);
    end
endmodule