module top_tb;
    // Test bench signals
    reg clk;
    reg reset;
    reg [6:0] midi_in;
    reg note_on;
    reg [1:0] wav_sel;
    reg [15:0] attack_time;
    reg [15:0] decay_time;
    reg [7:0] sustain_level;
    reg [15:0] release_time;
    wire pwm_audio_out;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .note_on(note_on),
        .wav_sel(wav_sel),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .pwm_audio_out(pwm_audio_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (adjust if needed)
    end

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;
        midi_in = 0;
        note_on = 0;
        wav_sel = 0;
        attack_time = 100;    // 100ms attack
        decay_time = 200;     // 200ms decay
        sustain_level = 128;  // 50% sustain
        release_time = 300;   // 300ms release

        // Wait for a longer reset duration
        #1000;
        reset = 0;

        // Test note sequence
        midi_in = 7'd60;  // Middle C
        note_on = 1;
        #10000000;  // Hold note for 10ms
        note_on = 0;
        #10000000;  // Release note for 10ms

        midi_in = 7'd72;  // C5
        note_on = 1;
        #10000000;
        note_on = 0;
        #10000000;

        // Add more test cases as needed

        // Finish the simulation
        #1000;
        $finish;
    end

    // Monitor PWM output
    initial begin
        $monitor("Time=%0t pwm_audio_out=%b", $time, pwm_audio_out);
    end

    // Generate waveform file
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end

endmodule