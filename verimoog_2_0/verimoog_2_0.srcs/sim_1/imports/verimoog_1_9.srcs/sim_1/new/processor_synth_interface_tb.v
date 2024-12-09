`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 08:38:59 PM
// Design Name: 
// Module Name: processor_synth_interface_tb
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

module processor_integration_tb();
    
    // Clock and reset
    reg clk;
    reg rst;
    
    // MIDI signals
    reg midi_rx;
    wire pwm_audio_out;
    
    // Debug signals
    wire [15:0] instruction;
    wire [7:0] proc_data_out;
    wire [7:0] proc_data_in;
    wire [7:0] port_addr;
    wire proc_write;
    wire proc_read;
    wire [10:0] inst_addr;
    
    // Additional debug signals
    wire midi_rx_sync;      // Synchronized MIDI input
    wire [7:0] midi_data;   // Current MIDI byte being processed
    wire midi_valid;        // MIDI data valid signal
    wire [2:0] midi_state;  // MIDI receiver state
    
    // Synth debug signals
    wire [1:0] wav_sel;
    wire [7:0] midi_note_sync;
    wire note_on_sync;
    wire note_valid_sync;
    
    // Task to send MIDI byte with status monitoring
    task send_midi_byte;
        input [7:0] data;
        integer i;
        begin
            $display("Sending MIDI byte: %h", data);
            // Start bit
            midi_rx = 0;
            #32000;
            
            // Data bits with monitoring
            for(i = 0; i < 8; i = i + 1) begin
                midi_rx = data[i];
                #32000;
                $display("MIDI bit %d = %b, Time=%t", i, data[i], $time);
            end
            
            // Stop bit
            midi_rx = 1;
            #32000;
            
            // Status check
            $display("MIDI byte sent. Current state: note=%h, on=%b, valid=%b",
                     midi_note_sync, note_on_sync, note_valid_sync);
        end
    endtask
    
    // Instantiate top module with proper port connections
    top uut (
        .clk(clk),
        .reset(rst),
        .midi_rx(midi_rx),
        .pwm_audio_out(pwm_audio_out)
    );
    
    // Internal signal assignments
    assign instruction = uut.processor_inst.instruction;
    assign inst_addr = uut.processor_inst.inst_addr;
    assign proc_data_out = uut.processor_inst.data_out;
    assign proc_data_in = uut.processor_inst.data_in;
    assign port_addr = uut.processor_inst.port_addr;
    assign proc_write = uut.processor_inst.write_e;
    assign proc_read = uut.processor_inst.read_e;
    
    // MIDI debug signal assignments
    assign midi_rx_sync = uut.midi_input_inst.midi_rx;
    assign midi_data = uut.midi_input_inst.rx_data;
    assign midi_valid = uut.midi_input_inst.note_valid;
    assign midi_state = uut.midi_input_inst.state;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize
        rst = 1;
        midi_rx = 1;
        
        // Reset sequence
        #100;
        rst = 0;
        #100;
        
        // Wait for initialization
        #2000;
        
        // Send complete MIDI sequence with monitoring
        $display("\nTest 1: MIDI Note-On Sequence");
        send_midi_byte(8'h90);  // Note-on status
        #64000; // Extra delay between bytes
        send_midi_byte(8'h3C);  // Note number (middle C)
        #64000;
        send_midi_byte(8'h40);  // Velocity
        
        // Monitor processor response
        #200000;
        
        // Send Note-off sequence
        $display("\nTest 2: MIDI Note-Off Sequence");
        send_midi_byte(8'h80);  // Note-off status
        #64000;
        send_midi_byte(8'h3C);  // Same note
        #64000;
        send_midi_byte(8'h00);  // Zero velocity
        
        // Final monitoring
        #200000;
        $display("\nTest sequence complete");
        $finish;
    end
    
    // Enhanced monitoring
    initial begin
        $monitor("Time=%0t PC=%h Instr=%h MIDI_State=%h Data=%h Note=%h On=%b Valid=%b",
                 $time, inst_addr, instruction, midi_state, midi_data,
                 midi_note_sync, note_on_sync, note_valid_sync);
    end

endmodule