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

`timescale 1ns / 1ps

module processor_synth_tb;
   // Clock and reset signals
   reg clk;
   reg reset;
   reg midi_rx;
   wire pwm_audio_out;

   // Debug signals
   wire [15:0] instruction;
   wire [7:0] proc_data_out, proc_data_in; 
   wire [1:0] wav_sel;
   wire midi_valid_sync, note_on_sync;
   wire [6:0] midi_note_sync;
   wire [7:0] wav_out;

   // Clock generation
   initial begin
       clk = 0;
       forever #5 clk = ~clk; 
   end

   // Instantiate DUT
   top dut (
       .clk(clk),
       .reset(reset),
       .midi_rx(midi_rx),
       .pwm_audio_out(pwm_audio_out)
   );

   // Debug signal assignments
   assign instruction = dut.processor_inst.instruction;
   assign proc_data_out = dut.processor_inst.data_out;
   assign proc_data_in = dut.processor_inst.data_in;
   assign wav_sel = dut.interface_inst.wav_sel;
   assign midi_valid_sync = dut.interface_inst.midi_valid_sync;
   assign note_on_sync = dut.interface_inst.note_on_sync;
   assign midi_note_sync = dut.interface_inst.midi_note_sync;
   assign wav_out = dut.synth_inst.wav_out;

   // MIDI message generator
   task send_midi_note_on;
       input [7:0] note;
       begin
           // MIDI Note On message (0x90)
           midi_rx = 0; #32000; // Start bit
           midi_rx = 1; #32000; // 0x90 byte
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 1; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 1; #32000; // Stop bit
           
           // Note number
           midi_rx = 0; #32000; // Start bit
           repeat(8) begin
               midi_rx = note[0];
               note = note >> 1;
               #32000;
           end
           midi_rx = 1; #32000; // Stop bit
           
           // Velocity (64)
           midi_rx = 0; #32000; // Start bit
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 1; #32000;
           midi_rx = 1; #32000;
           midi_rx = 1; #32000;
           midi_rx = 0; #32000;
           midi_rx = 1; #32000; // Stop bit
       end
   endtask

   task send_midi_note_off;
       input [7:0] note;
       begin
           // MIDI Note Off message (0x80)
           midi_rx = 0; #32000;
           midi_rx = 1; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 0; #32000;
           midi_rx = 1; #32000;
           
           // Note number
           midi_rx = 0; #32000;
           repeat(8) begin
               midi_rx = note[0];
               note = note >> 1;
               #32000;
           end
           midi_rx = 1; #32000;
           
           // Velocity (0)
           midi_rx = 0; #32000;
           repeat(8) begin
               midi_rx = 0;
               #32000;
           end
           midi_rx = 1; #32000;
       end
   endtask

   // Test stimulus
   initial begin
       // Initialize
       reset = 1;
       midi_rx = 1;
       #200;  // Longer reset period
       reset = 0;
       #100;
       
       // Verify instruction fetch
       #1000;

       // Test sequence
       send_midi_note_on(8'h3C);  // Middle C
       #500000;
       send_midi_note_off(8'h3C);
       #500000;
       
       send_midi_note_on(8'h40);  // E4
       #500000;
       send_midi_note_off(8'h40);
       #500000;

       #1000000;
       $finish;
   end

   // Debug monitoring
   initial begin
       $monitor("Time=%t rst=%b instr=%h data_out=%h data_in=%h wav=%h midi_valid=%b note_on=%b note=%h wav_out=%h", 
                $time, reset, instruction, proc_data_out, proc_data_in, wav_sel,
                midi_valid_sync, note_on_sync, midi_note_sync, wav_out);
                
       $dumpfile("processor_synth.vcd");
       $dumpvars(0, processor_synth_tb);
   end

endmodule