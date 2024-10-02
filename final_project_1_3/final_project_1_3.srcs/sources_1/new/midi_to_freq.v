`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 07:11:32 PM
// Design Name: 
// Module Name: midi_to_freq
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


module midi_to_freq(
    input wire [6:0] midi_in,
    output reg [31:0] freq_out
    );
    
    initial begin
        freq_out = 32'd0;
    end

    always@(midi_in) begin
        case(midi_in)
            7'd48: freq_out = 32'd131;      //C3
            7'd49: freq_out = 32'd139;
            7'd50: freq_out = 32'd147;
            7'd51: freq_out = 32'd156;
            7'd52: freq_out = 32'd165;
            7'd53: freq_out = 32'd175;
            7'd54: freq_out = 32'd185;
            7'd55: freq_out = 32'd196;
            7'd56: freq_out = 32'd208;
            7'd57: freq_out = 32'd220;
            7'd58: freq_out = 32'd233;
            7'd59: freq_out = 32'd247;
            7'd60: freq_out = 32'd262;
            7'd61: freq_out = 32'd277;
            7'd62: freq_out = 32'd294;
            7'd63: freq_out = 32'd311;
            7'd64: freq_out = 32'd330;
            7'd65: freq_out = 32'd349;
            7'd66: freq_out = 32'd370;
            7'd67: freq_out = 32'd392;
            7'd68: freq_out = 32'd415;
            7'd69: freq_out = 32'd440;
            7'd70: freq_out = 32'd466;
            7'd71: freq_out = 32'd494;
            7'd72: freq_out = 32'd523;
            7'd73: freq_out = 32'd554;
            7'd74: freq_out = 32'd587;
            7'd75: freq_out = 32'd622;
            7'd76: freq_out = 32'd659;
            7'd77: freq_out = 32'd698;
            7'd78: freq_out = 32'd740;
            7'd79: freq_out = 32'd784;
            7'd80: freq_out = 32'd831;
            7'd81: freq_out = 32'd880;
            7'd82: freq_out = 32'd932;
            7'd83: freq_out = 32'd988;
            7'd84: freq_out = 32'd1047;     //C6
            default: freq_out = 32'd0;
        endcase
    end            
endmodule
