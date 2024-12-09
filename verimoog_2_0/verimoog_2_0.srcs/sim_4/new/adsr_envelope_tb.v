`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 03:49:11 PM
// Design Name: 
// Module Name: adsr_envelope_tb
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

module adsr_envelope_tb();

    // Inputs
    reg clk;
    reg reset;
    reg voice_trigger;
    reg voice_active;
    reg [15:0] attack_time;
    reg [15:0] decay_time;
    reg [7:0] sustain_level;
    reg [15:0] release_time;
    reg [7:0] voice_in;

    // Outputs
    wire [7:0] voice_out;

    // Instantiate the Unit Under Test (UUT)
    adsr_envelope uut (
        .clk(clk),
        .reset(reset),
        .voice_trigger(voice_trigger),
        .voice_active(voice_active),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .voice_in(voice_in),
        .voice_out(voice_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        voice_trigger = 0;
        voice_active = 0;
        attack_time = 16'd10;  // 10 clock cycles
        decay_time = 16'd20;   // 20 clock cycles
        sustain_level = 8'd100; // Sustain level at mid-scale
        release_time = 16'd30;  // 30 clock cycles
        voice_in = 8'd128;      // Mid-scale input

        // Reset pulse
        #10 reset = 0;

        // Test Case 1: Simple Trigger
        #10 voice_trigger = 1;
        #20 voice_trigger = 0;
        voice_active = 1;
        #50 voice_active = 0;

        // Test Case 2: Modify ADSR parameters
        #10 attack_time = 16'd15;
        decay_time = 16'd25;
        sustain_level = 8'd200;
        release_time = 16'd40;
        voice_trigger = 1;
        #20 voice_trigger = 0;
        voice_active = 1;
        #50 voice_active = 0;

        // Test Case 3: Edge Case - Sustain Level 0
        #10 sustain_level = 8'd0;
        voice_trigger = 1;
        #20 voice_trigger = 0;
        voice_active = 1;
        #50 voice_active = 0;

        // Test Case 4: Long Release Time
        #10 release_time = 16'd100;
        voice_trigger = 1;
        #20 voice_trigger = 0;
        voice_active = 1;
        #200 voice_active = 0;

        // End Simulation
        #100 $stop;
    end

endmodule


