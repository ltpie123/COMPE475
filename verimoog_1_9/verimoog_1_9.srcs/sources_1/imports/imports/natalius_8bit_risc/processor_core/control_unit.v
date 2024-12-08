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
    parameter fetch = 5'd0;
    parameter decode = 5'd1;
    parameter ldi = 5'd2;
    parameter ldm = 5'd3;
    parameter stm = 5'd4;
    parameter cmp = 5'd5;
    parameter add = 5'd6;
    parameter sub = 5'd7;
    parameter andi = 5'd8;
    parameter oor = 5'd9;
    parameter xori = 5'd10;
    parameter jmp = 5'd11;
    parameter jpz = 5'd12;
    parameter jnz = 5'd13;
    parameter jpc = 5'd14;
    parameter jnc = 5'd15;
    parameter csr = 5'd16;
    parameter ret = 5'd17;
    parameter adi = 5'd18;
    parameter csz = 5'd19;
    parameter cnz = 5'd20;
    parameter csc = 5'd21;
    parameter cnc = 5'd22;
    parameter sl0 = 5'd23;
    parameter sl1 = 5'd24;
    parameter sr0 = 5'd25;
    parameter sr1 = 5'd26;
    parameter rrl = 5'd27;
    parameter rrr = 5'd28;
    parameter noti = 5'd29;
    parameter nop = 5'd30;

    wire [4:0] opcode;
    reg [4:0] state;
    
    assign opcode = instruction[15:11];

    // Task to initialize/reset all control signals
    task initialize_control_signals;
        begin
            state = fetch;
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
        end
    endtask

    // Initial block
    initial begin
        $display("Control Unit initialized");
        initialize_control_signals();
    end

    // Reset and state machine logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            initialize_control_signals();
            $display("Reset detected, state set to fetch");
        end
        else begin
            case (state)
                fetch: begin
                    ldpc <= 0;
                    state <= decode;
                    $display("Time=%0t: Fetch -> Decode", $time);
                end
                
                decode: begin
                    $display("Time=%0t Decoding Instruction=%h", $time, instruction);
                    $display("Opcode=%h Reg=%h Addr/Data=%h", instruction[15:11], instruction[10:8], instruction[7:0]);
                    case (opcode)
                        5'd2: begin 
                            state <= ldi;
                            ldpc <= 1;
                        end
                        5'd3: state <= ldm;
                        5'd4: state <= stm;
                        5'd5: state <= cmp;
                        5'd6: state <= add;
                        5'd7: state <= sub;
                        5'd8: state <= andi;
                        5'd9: state <= oor;
                        5'd10: state <= xori;
                        5'd11: state <= jmp;
                        5'd12: state <= jpz;
                        5'd13: state <= jnz;
                        5'd14: state <= jpc;
                        5'd15: state <= jnc;
                        5'd16: state <= csr;
                        5'd17: state <= ret;
                        5'd18: state <= adi;
                        5'd19: state <= csz;
                        5'd20: state <= cnz;
                        5'd21: state <= csc;
                        5'd22: state <= cnc;
                        5'd23: state <= sl0;
                        5'd24: state <= sl1;
                        5'd25: state <= sr0;
                        5'd26: state <= sr1;
                        5'd27: state <= rrl;
                        5'd28: state <= rrr;
                        5'd29: state <= noti;
                        default: begin
                            state <= nop;
                            ldpc <= 1;
                        end
                    endcase
                end

                default: begin
                    state <= fetch;
                    $display("Time=%0t: State %0d -> Fetch", $time, state);
                    ldpc <= 0;
                end
            endcase
        end
    end

    // Combinational control signal logic
    always @(*) begin
        case (state)
            fetch: begin
                ldpc = 0;
            end
            
            decode: begin
                ldpc = 0;
                if (opcode == stm) begin
                    raa = instruction[10:8];
                    port_addr = instruction[7:0];
                end else if (opcode == ldm) begin
                    wa = instruction[10:8];
                    port_addr = instruction[7:0];
                end else if (opcode == ret) begin
                    rd_en = 1;
                end
            end

            ldi: begin
                selk = 1;
                KTE = instruction[7:0];
                we = 1;
                wa = instruction[10:8];
            end

            stm: begin
                raa = instruction[10:8];
                write_e = 1;
                port_addr = instruction[7:0];
            end

            jmp: begin
                naddress = instruction[10:0];
                selpc = 1;
                ldpc = 1;
                $display("JMP: Setting address to %h", instruction[10:0]);
            end

            default: begin
                opalu = 4;
            end
        endcase
    end

endmodule