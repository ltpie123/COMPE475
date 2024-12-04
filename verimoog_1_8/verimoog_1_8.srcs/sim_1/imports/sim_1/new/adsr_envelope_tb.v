`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 08:31:18 PM
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

module adsr_envelope_tb;

    // Test bench signals
    reg clk;
    reg reset;
    reg voice_trigger;
    reg voice_active;
    reg [15:0] attack_time;
    reg [15:0] decay_time;
    reg [7:0] sustain_level;
    reg [15:0] release_time;
    reg [7:0] voice_in;
    wire [7:0] voice_out;

    // Instantiate the ADSR envelope generator
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
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;
        voice_trigger = 0;
        voice_active = 0;
        attack_time = 16'd100;
        decay_time = 16'd200;
        sustain_level = 8'd128;
        release_time = 16'd300;
        voice_in = 8'd128;

        // Release reset
        #100;
        reset = 0;

        // Test attack phase
        $display("Testing attack phase...");
        voice_trigger = 1;
        voice_active = 1;
        #1000;
        if (voice_out != 8'hFF) begin
            $error("Attack phase did not reach maximum");
        end

        // Test decay phase
        $display("Testing decay phase...");
        #2000;
        if (voice_out != sustain_level) begin
            $error("Decay phase did not reach sustain level");
        end

        // Test sustain phase
        $display("Testing sustain phase...");
        #5000;
        if (voice_out != sustain_level) begin
            $error("Sustain phase did not maintain sustain level");
        end

        // Test release phase
        $display("Testing release phase...");
        voice_trigger = 0;
        voice_active = 0;
        #3000;
        if (voice_out != 8'h00) begin
            $error("Release phase did not reach zero");
        end

        $display("Simulation complete");
        $finish;
    end

    // Monitor ADSR envelope output
    initial begin
        $monitor("Time: %0t, Voice Out: %h", $time, voice_out);
    end

endmodule