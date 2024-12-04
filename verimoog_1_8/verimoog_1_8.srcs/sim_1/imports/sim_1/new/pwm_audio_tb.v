`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 08:31:55 PM
// Design Name: 
// Module Name: pwm_audio_tb
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

module pwm_audio_tb;
    // Test bench signals
    reg clk;
    reg reset;
    reg [7:0] audio_in;
    wire pwm_out;

    // Instantiate PWM audio module
    pwm_audio uut (
        .clk(clk),
        .reset(reset),
        .audio_in(audio_in),
        .pwm_out(pwm_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize waveform dumps
        $dumpfile("pwm_audio_tb.vcd");
        $dumpvars(0, pwm_audio_tb);
        
        // Initialize signals
        reset = 1;
        audio_in = 8'h80; // Middle value
        
        // Release reset
        #100;
        reset = 0;
        #100;

        // Test different audio levels
        // Test low value
        $display("Testing low value...");
        audio_in = 8'h00;
        #1000;

        // Test mid-low value
        $display("Testing mid-low value...");
        audio_in = 8'h40;
        #1000;

        // Test middle value
        $display("Testing middle value...");
        audio_in = 8'h80;
        #1000;

        // Test mid-high value
        $display("Testing mid-high value...");
        audio_in = 8'hC0;
        #1000;

        // Test high value
        $display("Testing high value...");
        audio_in = 8'hFF;
        #1000;

        // Test reset during operation
        $display("Testing reset behavior...");
        reset = 1;
        #100;
        reset = 0;
        #100;

        // Test rapid value changes
        $display("Testing rapid value changes...");
        repeat(10) begin
            audio_in = $random;
            #100;
        end

        $display("Simulation complete");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t audio_in=%h pwm_out=%b", 
                 $time, audio_in, pwm_out);
    end

endmodule