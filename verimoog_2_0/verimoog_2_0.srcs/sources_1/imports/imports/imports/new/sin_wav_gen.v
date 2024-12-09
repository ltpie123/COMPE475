`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/27/2024
// Design Name: Sine Wave Generator
// Module Name: sin_wav_gen
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Look-up table based sine wave generator with phase accumulator.
//    Produces band-limited sine waves with minimal harmonic distortion.
//
// Key Features:
//    - 256-point sine look-up table
//    - Phase-accurate frequency synthesis
//    - 8-bit amplitude resolution
//    - Continuous phase operation
//
// Signal Information:
//    Inputs:
//        clk       - 100MHz system clock
//        reset     - Active high reset
//        freq      - 32-bit frequency control word (Hz)
//    Outputs:
//        wav_out   - 8-bit sine wave output
//
// Implementation Details:
//    - Look-up table initialization uses $sin function
//    - Fixed-point phase accumulation
//    - Table size: 256 entries
//    - Output range: 0 to 255 (centered at 128)
//
// Mathematical Basis:
//    - Phase Increment = (freq * 2^32) / clock_freq
//    - Table Index = phase_accumulator[31:24]
//    - Sine Scaling = sin(2? * index / 256) * 127 + 128
//
// Performance:
//    - THD: < 0.5% (theoretical)
//    - Frequency Resolution: 0.023 Hz
//    - Amplitude Resolution: 8 bits
//
// Dependencies: None
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Could implement linear interpolation
//    - Consider larger table for better resolution
//    - Possible cubic interpolation enhancement
//////////////////////////////////////////////////////////////////////////////////

module sin_wav_gen (
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    reg [31:0] phase_accumulator;
    reg [31:0] phase_increment;
    
    // Pre-calculated sine lookup table with 256 values
    // Values are 8-bit unsigned (0-255), centered at 128
    reg [7:0] sine_table [0:255];
    initial begin
        sine_table[0] = 128; sine_table[1] = 131; sine_table[2] = 134; sine_table[3] = 137;
        sine_table[4] = 140; sine_table[5] = 143; sine_table[6] = 146; sine_table[7] = 149;
        sine_table[8] = 152; sine_table[9] = 155; sine_table[10] = 158; sine_table[11] = 161;
        sine_table[12] = 164; sine_table[13] = 167; sine_table[14] = 170; sine_table[15] = 173;
        sine_table[16] = 176; sine_table[17] = 179; sine_table[18] = 182; sine_table[19] = 185;
        sine_table[20] = 188; sine_table[21] = 190; sine_table[22] = 193; sine_table[23] = 196;
        sine_table[24] = 198; sine_table[25] = 201; sine_table[26] = 203; sine_table[27] = 206;
        sine_table[28] = 208; sine_table[29] = 211; sine_table[30] = 213; sine_table[31] = 215;
        sine_table[32] = 218; sine_table[33] = 220; sine_table[34] = 222; sine_table[35] = 224;
        sine_table[36] = 226; sine_table[37] = 228; sine_table[38] = 230; sine_table[39] = 232;
        sine_table[40] = 234; sine_table[41] = 235; sine_table[42] = 237; sine_table[43] = 238;
        sine_table[44] = 240; sine_table[45] = 241; sine_table[46] = 243; sine_table[47] = 244;
        sine_table[48] = 245; sine_table[49] = 246; sine_table[50] = 247; sine_table[51] = 248;
        sine_table[52] = 249; sine_table[53] = 250; sine_table[54] = 251; sine_table[55] = 251;
        sine_table[56] = 252; sine_table[57] = 252; sine_table[58] = 253; sine_table[59] = 253;
        sine_table[60] = 253; sine_table[61] = 254; sine_table[62] = 254; sine_table[63] = 254;
        sine_table[64] = 254; sine_table[65] = 254; sine_table[66] = 254; sine_table[67] = 253;
        sine_table[68] = 253; sine_table[69] = 253; sine_table[70] = 252; sine_table[71] = 252;
        sine_table[72] = 251; sine_table[73] = 251; sine_table[74] = 250; sine_table[75] = 249;
        sine_table[76] = 248; sine_table[77] = 247; sine_table[78] = 246; sine_table[79] = 245;
        sine_table[80] = 244; sine_table[81] = 243; sine_table[82] = 241; sine_table[83] = 240;
        sine_table[84] = 238; sine_table[85] = 237; sine_table[86] = 235; sine_table[87] = 234;
        sine_table[88] = 232; sine_table[89] = 230; sine_table[90] = 228; sine_table[91] = 226;
        sine_table[92] = 224; sine_table[93] = 222; sine_table[94] = 220; sine_table[95] = 218;
        sine_table[96] = 215; sine_table[97] = 213; sine_table[98] = 211; sine_table[99] = 208;
        sine_table[100] = 206; sine_table[101] = 203; sine_table[102] = 201; sine_table[103] = 198;
        sine_table[104] = 196; sine_table[105] = 193; sine_table[106] = 190; sine_table[107] = 188;
        sine_table[108] = 185; sine_table[109] = 182; sine_table[110] = 179; sine_table[111] = 176;
        sine_table[112] = 173; sine_table[113] = 170; sine_table[114] = 167; sine_table[115] = 164;
        sine_table[116] = 161; sine_table[117] = 158; sine_table[118] = 155; sine_table[119] = 152;
        sine_table[120] = 149; sine_table[121] = 146; sine_table[122] = 143; sine_table[123] = 140;
        sine_table[124] = 137; sine_table[125] = 134; sine_table[126] = 131; sine_table[127] = 128;
        sine_table[128] = 125; sine_table[129] = 122; sine_table[130] = 119; sine_table[131] = 116;
        sine_table[132] = 113; sine_table[133] = 110; sine_table[134] = 107; sine_table[135] = 104;
        sine_table[136] = 101; sine_table[137] = 98; sine_table[138] = 95; sine_table[139] = 92;
        sine_table[140] = 89; sine_table[141] = 86; sine_table[142] = 83; sine_table[143] = 80;
        sine_table[144] = 77; sine_table[145] = 74; sine_table[146] = 71; sine_table[147] = 69;
        sine_table[148] = 66; sine_table[149] = 63; sine_table[150] = 60; sine_table[151] = 58;
        sine_table[152] = 55; sine_table[153] = 53; sine_table[154] = 50; sine_table[155] = 48;
        sine_table[156] = 45; sine_table[157] = 43; sine_table[158] = 40; sine_table[159] = 38;
        sine_table[160] = 36; sine_table[161] = 34; sine_table[162] = 32; sine_table[163] = 30;
        sine_table[164] = 28; sine_table[165] = 26; sine_table[166] = 24; sine_table[167] = 22;
        sine_table[168] = 20; sine_table[169] = 19; sine_table[170] = 17; sine_table[171] = 16;
        sine_table[172] = 14; sine_table[173] = 13; sine_table[174] = 11; sine_table[175] = 10;
        sine_table[176] = 9; sine_table[177] = 8; sine_table[178] = 7; sine_table[179] = 6;
        sine_table[180] = 5; sine_table[181] = 4; sine_table[182] = 3; sine_table[183] = 3;
        sine_table[184] = 2; sine_table[185] = 2; sine_table[186] = 1; sine_table[187] = 1;
        sine_table[188] = 1; sine_table[189] = 0; sine_table[190] = 0; sine_table[191] = 0;
        sine_table[192] = 0; sine_table[193] = 0; sine_table[194] = 0; sine_table[195] = 1;
        sine_table[196] = 1; sine_table[197] = 1; sine_table[198] = 2; sine_table[199] = 2;
        sine_table[200] = 3; sine_table[201] = 3; sine_table[202] = 4; sine_table[203] = 5;
        sine_table[204] = 6; sine_table[205] = 7; sine_table[206] = 8; sine_table[207] = 9;
        sine_table[208] = 10; sine_table[209] = 11; sine_table[210] = 13; sine_table[211] = 14;
        sine_table[212] = 16; sine_table[213] = 17; sine_table[214] = 19; sine_table[215] = 20;
        sine_table[216] = 22; sine_table[217] = 24; sine_table[218] = 26; sine_table[219] = 28;
        sine_table[220] = 30; sine_table[221] = 32; sine_table[222] = 34; sine_table[223] = 36;
        sine_table[224] = 38; sine_table[225] = 40; sine_table[226] = 43; sine_table[227] = 45;
        sine_table[228] = 48; sine_table[229] = 50; sine_table[230] = 53; sine_table[231] = 55;
        sine_table[232] = 58; sine_table[233] = 60; sine_table[234] = 63; sine_table[235] = 66;
        sine_table[236] = 69; sine_table[237] = 71; sine_table[238] = 74; sine_table[239] = 77;
        sine_table[240] = 80; sine_table[241] = 83; sine_table[242] = 86; sine_table[243] = 89;
        sine_table[244] = 92; sine_table[245] = 95; sine_table[246] = 98; sine_table[247] = 101;
        sine_table[248] = 104; sine_table[249] = 107; sine_table[250] = 110; sine_table[251] = 113;
        sine_table[252] = 116; sine_table[253] = 119; sine_table[254] = 122; sine_table[255] = 125;
    end

    // Calculate phase increment based on 100 MHz clock
    wire [31:0] phase_inc_calc;
    assign phase_inc_calc = ((freq * 32'd4294967296) / 100_000_000);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            wav_out <= 8'h80; // Middle value (128)
        end else begin
            // Update phase increment
            phase_increment <= phase_inc_calc[31:0];

            // Update phase accumulator
            phase_accumulator <= phase_accumulator + phase_increment;

            // Use the top 8 bits of the phase accumulator to index into the sine table
            wav_out <= sine_table[phase_accumulator[31:24]];
        end
    end

endmodule