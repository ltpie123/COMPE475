`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 02:05:52 AM
// Design Name: 
// Module Name: midi_to_freq_tb
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

module midi_to_freq_tb;

    // Inputs
    reg [6:0] midi_in;

    // Outputs
    wire [31:0] freq_out;

    // Instantiate the Unit Under Test (UUT)
    midi_to_freq uut (
        .midi_in(midi_in),
        .freq_out(freq_out)
    );

    initial begin
        // Test case 1: Middle C (C4)
        midi_in = 7'd60; #10;
        $display("MIDI: %d, Frequency: %d", midi_in, freq_out);

        // Test case 2: Concert A (A4)
        midi_in = 7'd69; #10;
        $display("MIDI: %d, Frequency: %d", midi_in, freq_out);

        // Test case 3: Lowest note in range (C3)
        midi_in = 7'd48; #10;
        $display("MIDI: %d, Frequency: %d", midi_in, freq_out);

        // Test case 4: Highest note in range (C6)
        midi_in = 7'd84; #10;
        $display("MIDI: %d, Frequency: %d", midi_in, freq_out);

        // Test case 5: Note outside valid range (0)
        midi_in = 7'd0; #10;
        $display("MIDI: %d, Frequency: %d", midi_in, freq_out);

        // Test case 6: Note outside valid range (127)
        midi_in = 7'd127; #10;
        $display("MIDI: %d, Frequency: %d", midi_in, freq_out);

        // Test case 7: Random note in range (G4)
        midi_in = 7'd67; #10;
        $display("MIDI: %d, Frequency: %d", midi_in, freq_out);

        // End simulation
        $stop;
    end

endmodule
