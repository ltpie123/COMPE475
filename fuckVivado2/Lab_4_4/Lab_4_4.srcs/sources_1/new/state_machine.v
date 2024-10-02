`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 01:49:24 PM
// Design Name: 
// Module Name: state_machine
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


module state_machine (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire clk_enable,
    input wire done,
    output reg [2:0] current_state,
    output reg [2:0] next_state
);
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        CLEANUP = 3'b100
    } state_t;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                next_state = start ? START : IDLE;
            end
            START: begin
                next_state = clk_enable ? DATA : START;
            end
            DATA: begin
                next_state = done ? STOP : DATA;
            end
            STOP: begin
                next_state = clk_enable ? CLEANUP : STOP;
            end
            CLEANUP: begin
                next_state = IDLE; // Return to idle
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
