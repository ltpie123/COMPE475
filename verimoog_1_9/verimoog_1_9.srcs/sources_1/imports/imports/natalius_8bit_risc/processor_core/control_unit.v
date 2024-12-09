`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       Universidad Pontificia Bolivariana
// Engineer:      Fabio Andres Guzman Figueroa
// 
// Create Date:    19:48:58 05/14/2012 
// Design Name: 
// Module Name:    control_unit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module control_unit(
    input clk,
    input rst,
    input [15:0] instruction,
    input z,
    input c,
    output reg [7:0] port_addr,
    output reg write_e,
    output reg read_e,
    output reg insel,
    output reg we,
    output reg [2:0] raa,
    output reg [2:0] rab,
    output reg [2:0] wa,
    output reg [2:0] opalu,
    output reg [2:0] sh,
    output reg selpc,
    output reg ldpc,
    output reg ldflag,
    output reg [10:0] naddress,
    output reg selk,
    output reg [7:0] KTE,
    input [10:0] stack_addr,
    output reg wr_en, rd_en,
    output reg [7:0] imm,
    output reg selimm
);

    // State definitions
    parameter FETCH = 3'd0;
    parameter DECODE = 3'd1;
    parameter EXECUTE = 3'd2;
    parameter WRITEBACK = 3'd3;

    // Instruction opcodes
    parameter LDI = 8'h02;
    parameter LDM = 8'h03;
    parameter STM = 8'h04;
    parameter JMP = 8'h0B;

    // Internal signals
    reg [2:0] state;
    reg [2:0] next_state;
    wire [7:0] opcode;
    reg instruction_valid;
    
    assign opcode = instruction[15:8];

    // Synchronous state update with async reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= FETCH;
            instruction_valid <= 0;
        end
        else begin
            state <= next_state;
            
            // Update instruction valid flag
            case (state)
                FETCH: instruction_valid <= 1;
                WRITEBACK: instruction_valid <= 0;
                default: instruction_valid <= instruction_valid;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            FETCH: begin
                next_state = DECODE;
            end
            
            DECODE: begin
                if (instruction_valid)
                    next_state = EXECUTE;
                else
                    next_state = DECODE;
            end
            
            EXECUTE: begin
                next_state = WRITEBACK;
            end
            
            WRITEBACK: begin
                next_state = FETCH;
            end
            
            default: next_state = FETCH;
        endcase
    end

    // Control signals - purely combinational
    always @(*) begin
        // Default assignments
        port_addr = 0;
        write_e = 0;
        read_e = 0;
        insel = 0;
        we = 0;
        raa = 0;
        rab = 0;
        wa = 0;
        opalu = 4;
        sh = 4;
        selpc = 0;
        ldpc = 0;
        ldflag = 0;
        naddress = 0;
        selk = 0;
        KTE = 0;
        wr_en = 0;
        rd_en = 0;
        imm = 0;
        selimm = 0;

        case (state)
            FETCH: begin
                // Hold all control signals
            end
            
            DECODE: begin
                if (instruction_valid) begin
                    case (opcode)
                        LDI: begin
                            wa = instruction[10:8];
                            KTE = instruction[7:0];
                        end
                        STM: begin
                            raa = instruction[10:8];
                            port_addr = instruction[7:0];
                        end
                        JMP: begin
                            naddress = instruction[10:0];
                        end
                    endcase
                end
            end
            
            EXECUTE: begin
                case (opcode)
                    LDI: begin
                        selk = 1;
                        we = 1;
                    end
                    
                    STM: begin
                        write_e = 1;
                    end
                    
                    JMP: begin
                        selpc = 1;
                        ldpc = 1;
                    end
                    
                    default: begin
                        // No operation
                    end
                endcase
            end
            
            WRITEBACK: begin
                if (!selpc) begin  // If not a jump instruction
                    ldpc = 1;      // Normal PC increment
                end
            end
        endcase
    end

    // Debug outputs
    always @(posedge clk) begin
        if (!rst) begin
            case (state)
                FETCH:    $display("Time=%0t State=FETCH PC_Control: ldpc=%b selpc=%b", $time, ldpc, selpc);
                DECODE:   $display("Time=%0t State=DECODE Opcode=%h Valid=%b", $time, opcode, instruction_valid);
                EXECUTE:  $display("Time=%0t State=EXECUTE Instruction=%h", $time, instruction);
                WRITEBACK: $display("Time=%0t State=WRITEBACK Next_PC_Update: ldpc=%b", $time, ldpc);
            endcase
        end
    end

endmodule