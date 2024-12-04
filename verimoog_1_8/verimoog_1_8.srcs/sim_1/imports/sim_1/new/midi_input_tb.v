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

    // Debug signals from midi_input module
    wire [2:0] dbg_state;
    wire [15:0] dbg_bit_counter;
    wire [7:0] dbg_rx_data;
    wire [3:0] dbg_bit_index;
    wire [7:0] dbg_status_byte;
    wire [7:0] dbg_data_byte1;
    wire [1:0] dbg_byte_count;

    // MIDI constants
    parameter MIDI_NOTE_ON = 8'h90;
    parameter MIDI_NOTE_OFF = 8'h80;
    parameter CLK_FREQ = 100_000_000;  // 100MHz
    parameter BAUD_RATE = 31250;       // Standard MIDI baud rate
    parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; // Should be 3200
    parameter BIT_PERIOD = (1_000_000_000 / BAUD_RATE); // 32000ns per bit

    // Instantiate the MIDI input module
    midi_input uut (
        .clk(clk),
        .reset(reset),
        .midi_rx(midi_rx),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid)
    );

    // Debug signal assignments
    assign dbg_state = uut.state;
    assign dbg_bit_counter = uut.bit_counter;
    assign dbg_rx_data = uut.rx_data;
    assign dbg_bit_index = uut.bit_index;
    assign dbg_status_byte = uut.status_byte;
    assign dbg_data_byte1 = uut.data_byte1;
    assign dbg_byte_count = uut.byte_count;

    // Clock generation - 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Task to send one MIDI byte
    task send_midi_byte;
        input [7:0] data;
        integer i;
        begin
            $display("Sending byte: %h", data);
            // Start bit (low)
            midi_rx = 0;
            #(BIT_PERIOD);
            
            // Data bits LSB first
            for (i = 0; i < 8; i = i + 1) begin
                midi_rx = data[i];
                #(BIT_PERIOD);
            end
            
            // Stop bit (high)
            midi_rx = 1;
            #(BIT_PERIOD);

            // Inter-byte delay
            #(BIT_PERIOD);
        end
    endtask

    // Task to play a note
    task play_note;
        input [6:0] note;
        begin
            $display("Playing note %d", note);
            send_midi_byte(MIDI_NOTE_ON);
            send_midi_byte(note);
            send_midi_byte(8'h00); // Dummy byte (ignored)
            
            // Wait for note_valid
            @(posedge note_valid);
            #(BIT_PERIOD * 2);
        end
    endtask

    // Task to release a note
    task release_note;
        input [6:0] note;
        begin
            $display("Releasing note %d", note);
            send_midi_byte(MIDI_NOTE_OFF);
            send_midi_byte(note);
            send_midi_byte(8'h00); // Dummy byte (ignored)
            
            // Wait for note_valid
            @(posedge note_valid);
            #(BIT_PERIOD * 2);
        end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        reset = 1;
        midi_rx = 1;

        // Reset for 100us
        #100000;
        reset = 0;
        #100000;

        // Test 1: Basic note on/off
        play_note(60);         // Middle C
        #(BIT_PERIOD * 100);   // Hold note
        release_note(60);      // Release Middle C
        #(BIT_PERIOD * 100);   // Wait

        // Test 2: Quick chord sequence
        play_note(60);         // C
        #(BIT_PERIOD * 10);
        play_note(64);         // E
        #(BIT_PERIOD * 10);
        play_note(67);         // G
        #(BIT_PERIOD * 100);   // Hold chord

        // Release chord
        release_note(60);      // C
        #(BIT_PERIOD * 10);
        release_note(64);      // E
        #(BIT_PERIOD * 10);
        release_note(67);      // G
        #(BIT_PERIOD * 100);   // Wait

        // Test 3: Chromatic scale
        for (integer i = 60; i <= 72; i = i + 1) begin
            play_note(i);      // Note on
            #(BIT_PERIOD * 30);
            release_note(i);   // Note off
            #(BIT_PERIOD * 10);
        end

        // Final wait
        #(BIT_PERIOD * 100);
        
        $finish;
    end

    // Detailed state monitoring
    reg [2:0] prev_state;
    always @(posedge clk) begin
        prev_state <= dbg_state;
        if (prev_state != dbg_state) begin
            $display("Time %t: State changed from %d to %d", 
                     $time, prev_state, dbg_state);
            $display("  bit_counter=%d, bit_index=%d, rx_data=%h", 
                     dbg_bit_counter, dbg_bit_index, dbg_rx_data);
            $display("  status_byte=%h, data_byte1=%h, byte_count=%d",
                     dbg_status_byte, dbg_data_byte1, dbg_byte_count);
        end
    end

    // Monitor MIDI messages
    always @(posedge note_valid) begin
        $display("Time=%t MIDI Message Complete: note=%d, on=%b, valid=%b", 
                 $time, midi_note, note_on, note_valid);
        $display("  Final values: status=%h, note=%h", 
                 dbg_status_byte, dbg_data_byte1);
    end

endmodule