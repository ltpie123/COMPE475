    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 09/26/2024 07:36:44 PM
    // Design Name: 
    // Module Name: sqr_wav_gen
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
    
    
    module sqr_wav_gen(
        input wire clk,
        input wire reset,
        input wire [31:0] freq,
        output reg [7:0] wav_out
        );
        
        reg [31:0] counter;
        reg [31:0] max;
        
        always @(posedge clk) begin
            if (reset) begin
                counter <= 0;
                wav_out <= 8'h00;
            end else begin
                if (counter == max) begin
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
                wav_out <= (counter < max / 2) ? 8'hff : 8'h00;
            end
        end
        
        always @(*) begin
            max = (freq == 0) ? 32'hFFFFFFFF : 50000000 / freq;
        end
    endmodule
